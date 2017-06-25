//  Created by dasdom on 21.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class GlobalCoordinator: PostsCoordinator {
    
    override func createViewController() -> GlobalViewController {
        let globalViewController = GlobalViewController(apiClient: apiClient)
        globalViewController.title = "Global"
        return globalViewController
    }
}
