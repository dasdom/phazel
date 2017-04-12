//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class NavigationControllerMock: UINavigationController {
    
    var pushedViewController: UIViewController?
    var didPop = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        didPop = true
        return super.popViewController(animated: animated)
    }
}
