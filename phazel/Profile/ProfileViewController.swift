//  Created by dasdom on 04.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

class ProfileViewController: PostsViewController {

    let user: User
    
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
        refreshControl?.beginRefreshing()
        self.apiClient.profilePosts(userId: id) { [weak self] result in
            
            if case .success(let dataArray) = result {
                var posts: [Post] = []
                for dict in dataArray {
                    posts.append(Post(dict: dict))
                }
                self?.dataSource?.add(posts: posts)
                
                self?.refreshControl?.endRefreshing()
            }
        }
    }
}
