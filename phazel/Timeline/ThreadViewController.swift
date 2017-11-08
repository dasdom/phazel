//  Created by dasdom on 21.10.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

import Roaster

class ThreadViewController: PostsViewController {

    let post: Post
    
    init(post: Post, apiClient: APIClientProtocol) {
        
        self.post = post
        
        super.init(apiClient: apiClient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource?.dataArray = []
        tableView.reloadData()
    }
    
    override func fetchPosts() {
        guard let threadIdString = post.threadId else { return }
        guard let threadId = Int(threadIdString) else { return }
        apiClient.threadFor(postId: threadId) { [weak self] result in
            
            self?.dataSource?.dataArray = []
            self?.tableView.reloadData()
            self?.process(result)
        }
    }
    
    override func process(_ result: (Result<[[String : Any]]>)) {
        self.refreshControl?.endRefreshing()
        if case .success(let dataArray) = result {
            var posts: [Post] = []
            for dict in dataArray {
                posts.append(Post(dict: dict))
            }
            self.dataSource?.add(posts: posts, adjustContentOffset: false)
        }
    }
}
