//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol PostsViewControllerDelegate: class {
    func viewDidAppear(viewController: UIViewController)
    func reply(to: Post)
}

class PostsViewController: UITableViewController {

    let apiClient: APIClientProtocol
    weak var delegate: PostsViewControllerDelegate?
    var dataSource: TableViewDataSource<PostsCoordinator>?
    var dummyCell = PostCell(style: .default, reuseIdentifier: "DummyCell")
    var indexPathOfExpandedCell: IndexPath?

    init(apiClient: APIClientProtocol) {
        
        self.apiClient = apiClient
        
        super.init(style: .plain)
    } 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPosts()
    }
    
    func fetchPosts() {
//        let post = dataSource?.object(at: IndexPath(row: 0, section: 0))
//        var sinceId: Int? = nil
//        if let sinceIdString = post?.id {
//            sinceId = Int(sinceIdString)
//        }
//        print(">>> sinceId: \(String(describing: sinceId))")
//        
//        self.apiClient.posts(before: nil, since: sinceId) { [weak self] result in
//            
//            if case .success(let dataArray) = result {
//                var posts: [Post] = []
//                for dict in dataArray {
//                    posts.append(Post(dict: dict))
//                }
//            }
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate?.viewDidAppear(viewController: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0.0
        if let post = dataSource?.object(at: indexPath) {
            dummyCell.configure(with: post, loadImage: false)
            let tableViewWidth = tableView.bounds.size.width
            let usernameHeight = dummyCell.usernameLabel.sizeThatFits(CGSize(width: 0.6 * tableViewWidth, height: CGFloat(200))).height
            let postTextHeight = dummyCell.postTextView.sizeThatFits(CGSize(width: 0.7375 * tableViewWidth, height: CGFloat(10000))).height
            let sourceHeight = dummyCell.sourceLabel.sizeThatFits(CGSize(width: 0.7375 * tableViewWidth, height: CGFloat(200))).height
            height = 8 + usernameHeight + 8 + postTextHeight + 8 + sourceHeight + 8
            if indexPath == indexPathOfExpandedCell {
                height += 30
            }
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        
        if indexPathOfExpandedCell == indexPath {
            indexPathOfExpandedCell = nil
        } else {
            indexPathOfExpandedCell = indexPath
        }
        
        tableView.endUpdates()
    }
}

extension PostsViewController: CellActionsProtocol {
    func reply(sender: UIButton) {
        let point = sender.convert(sender.center, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        guard let post = dataSource?.object(at: indexPath) else { return }
        
        delegate?.reply(to: post)
    }
}
