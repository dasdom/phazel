//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol PostsViewControllerDelegate: class {
    func viewDidAppear(viewController: UIViewController)
    func reply(_: UIViewController, to: Post)
    func viewController(_: UIViewController, tappedLink: Link)
    func viewController(_: UIViewController, tappedUser: User)
}

class PostsViewController: UITableViewController {

    let apiClient: APIClientProtocol
    weak var delegate: PostsViewControllerDelegate?
    var dataSource: TableViewDataSource<PostsCoordinator>? {
        didSet {
            if let dataSource = dataSource {
                let posts = unarchivePosts()
                dataSource.dataArray = posts
            }
        }
    }
    var dummyCell = PostCell(style: .default, reuseIdentifier: "DummyCell")
    var indexPathOfExpandedCell: IndexPath?
    var cellHeights: [String:CGFloat] = [:]

    init(apiClient: APIClientProtocol) {
        
        self.apiClient = apiClient
        
        super.init(style: .plain)
    } 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        
        fetchPosts()
    }
    
    func fetchPosts() {
        let post = dataSource?.object(at: IndexPath(row: 0, section: 0))
        var sinceId: Int? = nil
        if let sinceIdString = post?.id {
            sinceId = Int(sinceIdString)
        }
        print(">>> sinceId: \(String(describing: sinceId))")

        refreshControl?.beginRefreshing()
        self.apiClient.posts(before: nil, since: sinceId) { [weak self] result in
            
            if case .success(let dataArray) = result {
                var posts: [Post] = []
                for dict in dataArray {
                    posts.append(Post(dict: dict))
                }
                self?.dataSource?.add(posts: posts)
                self?.archivePosts()
                
                self?.refreshControl?.endRefreshing()
                
                if let indexPath = self?.indexPathOfExpandedCell {
                    self?.indexPathOfExpandedCell = IndexPath(row: indexPath.row + posts.count, section: indexPath.section)
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate?.viewDidAppear(viewController: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0.0
        if let post = dataSource?.object(at: indexPath) {
            
            if post.isDeleted {
                height = 0
            } else if let postId = post.id, let cellHeight = cellHeights[postId] {
                height = cellHeight
            } else {
                let tableViewWidth = tableView.bounds.size.width
                dummyCell.frame.size = CGSize(width: tableViewWidth, height: 300)
                dummyCell.configure(with: post, forPresentation: false)
                height = dummyCell.sourceLabel.frame.maxY + 8
                
                if let postId = post.id {
                    cellHeights[postId] = height
                }
            }
            if indexPath == indexPathOfExpandedCell {
                height += 30
            }
        }
        return height
    }
    
    func selectCell(at indexPath: IndexPath) {

        tableView.beginUpdates()
        
        let cell = tableView.cellForRow(at: indexPath) as? PostCell
        if indexPathOfExpandedCell == indexPath {
            indexPathOfExpandedCell = nil
            cell?.hideButtons()
            
            let previousSelectedPost = dataSource?.object(at: indexPath)
            previousSelectedPost?.isSelected = false
        } else {
            if let indexPathOfExpandedCell = indexPathOfExpandedCell {
                let previousExpandedCell = tableView.cellForRow(at: indexPathOfExpandedCell) as? PostCell
                previousExpandedCell?.hideButtons()
                
                let previousSelectedPost = dataSource?.object(at: indexPathOfExpandedCell)
                previousSelectedPost?.isSelected = false
            }
            indexPathOfExpandedCell = indexPath
            cell?.showButtons()
            
            let selectedPost = dataSource?.object(at: indexPath)
            selectedPost?.isSelected = true
        }
        
        tableView.endUpdates()
        
    }
}

extension PostsViewController: CellActionsProtocol {
    func reply(sender: UIButton) {
        let point = sender.convert(sender.center, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        guard let post = dataSource?.object(at: indexPath) else { return }
        
        delegate?.reply(self, to: post)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? PostCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let locationInCell = sender.location(in: cell)
        
        if cell.postTextView.frame.contains(locationInCell) {
            if !tappedPostEntity(tapGesture: sender, cell: cell, indexPath: indexPath) {
                selectCell(at: indexPath)
            }
        } else {
            guard let post = dataSource?.object(at: indexPath) else { return }
            if cell.avatarImageView.frame.contains(locationInCell) {
                guard let user = post.user else { return }
                user.content?.avatarImage?.image = cell.avatarImageView.image
                delegate?.viewController(self, tappedUser: user)
            } else {
                selectCell(at: indexPath)
            }
        }
    }
    
    func tappedPostEntity(tapGesture: UITapGestureRecognizer, cell: PostCell, indexPath: IndexPath) -> Bool {
        let locationInTextView = tapGesture.location(in: cell.postTextView)
        
        guard let textPosition = cell.postTextView.closestPosition(to: locationInTextView) else { return false }
        let offset = cell.postTextView.offset(from: cell.postTextView.beginningOfDocument, to: textPosition)
        print("offset: \(offset)")
        
        if let tappedLink = link(for: offset, at: indexPath) {
            delegate?.viewController(self, tappedLink: tappedLink)
            return true
        }
        return false
    }
    
    func link(for offset: Int, at indexPath: IndexPath) -> Link? {
        guard let post = dataSource?.object(at: indexPath) else { return nil }
        return post.link(at: offset)
    }
}

// MARK: - Archiving
extension PostsViewController {
    func postsPath() -> String {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            fatalError()
        }
        let postsPath = "\(documentsPath)/posts"
        if !FileManager.default.isWritableFile(atPath: postsPath) {
            try! FileManager.default.createDirectory(at: URL(fileURLWithPath: postsPath), withIntermediateDirectories: true, attributes: nil)
        }
        print("Path for posts: \(postsPath)")
        return "\(postsPath)/posts"
    }
    
    func archivePosts() {
        if let posts = dataSource?.dataArray {
            print("Writing \(posts.count) to disk.")
            let success = NSKeyedArchiver.archiveRootObject(posts, toFile: postsPath())
            print(success)
        }
    }
    
    func unarchivePosts() -> [Post] {
        guard let posts = NSKeyedUnarchiver.unarchiveObject(withFile: postsPath()) as? [Post] else {
            print("No posts found on disk.")
            return []
        }
        print("Reading \(posts.count) from disk.")
        return posts
    }
}

// MARK: - Helper
extension PostsViewController {
    
}
