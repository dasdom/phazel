//  Created by dasdom on 10.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
@testable import phazel

class TableViewDataSourceMock: TableViewDataSource<PostsCoordinator> {
    
    var storedPost: Post?
    var lastIndexPath: IndexPath?
    var addedPosts: [Post]?
    
    override func object(at indexPath: IndexPath) -> Post {
        lastIndexPath = indexPath
        return storedPost!
    }
    
    override func add(posts: [Post], adjustContentOffset: Bool) {
        addedPosts = posts
        super.add(posts: posts)
    }
}
