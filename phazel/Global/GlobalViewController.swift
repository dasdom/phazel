//  Created by dasdom on 20.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class GlobalViewController: PostsViewController {

    override func fetchPosts() {
        self.apiClient.globalPosts(before: nil, since: self.sinceId()) { [weak self] result in
            
            self?.process(result)
        }
    }
}
