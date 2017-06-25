//  Created by dasdom on 04.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

class ProfileViewController: PostsViewController {

    var user: User
    override var dataSource: TableViewDataSource<PostsCoordinator>? {
        get { return _dataSource }
        set { _dataSource = newValue }
    }
    
    init(user: User, apiClient: APIClientProtocol) {
        
        self.user = user
        
        super.init(apiClient: apiClient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileHeaderView = ProfileHeaderView()
        
        profileHeaderView.update(with: user)
        
        tableView.tableHeaderView = profileHeaderView
        
        guard let id = user.id else { return }
        apiClient.user(id: id) { result in
            if case .success(let userDict) = result {
                let fetchedUser = User(dict: userDict)
                profileHeaderView.update(with: fetchedUser)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.layoutHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.layoutHeaderView()
    }
    
    override func fetchPosts() {
        guard let id = user.id else { fatalError() }
//        refreshControl?.beginRefreshing()
        apiClient.profilePosts(userId: id) { [weak self] result in
            
            if case .success(let dataArray) = result {
                var posts: [Post] = []
                for dict in dataArray {
                    posts.append(Post(dict: dict))
                }
                self?.dataSource?.add(posts: posts, adjustContentOffset: false)
                
//                self?.refreshControl?.endRefreshing()
            }
        }
    }
}

extension ProfileViewController: ProfileActionsProtocol {
    @objc func follow() {
        guard let id = user.id else { fatalError() }
        apiClient.follow(!user.youFollow, userId: id) { [weak self] result in
            
            if case .success(let userDict) = result {
                let user = User(dict: userDict)
                guard let headerView = self?.tableView.tableHeaderView as? ProfileHeaderView else { return }
                self?.user = user
                headerView.updateFollowButton(with: user)
            }
        }
    }
}
