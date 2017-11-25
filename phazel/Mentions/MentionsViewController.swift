//  Created by dasdom on 24.11.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

class MentionsViewController: PostsViewController {

    var user: User

    init(user: User, apiClient: APIClientProtocol) {
        
        self.user = user
        
        super.init(apiClient: apiClient)
        
        refreshControl = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fetchPosts() {
        guard let id = user.id else { fatalError() }

        apiClient.mentions(userId: id) { [weak self] result in
            
            if case .success(let dataArray) = result {
                var posts: [Post] = []
                for dict in dataArray {
                    posts.append(Post(dict: dict))
                }
                self?.dataSource?.add(posts: posts, adjustContentOffset: false)
            }
        }
    }
}
