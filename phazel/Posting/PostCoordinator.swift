//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

final class PostCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
    var childViewControllers = [UIViewController]()

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let postViewController = PostViewController(contentView: PostView())
        childViewControllers.append(postViewController)
        
        window.rootViewController = postViewController
    }
}

extension PostCoordinator: PostViewControllerDelegate {
    
    func postDidSucceed(viewController: PostViewController, with postId: String) {
        
    }
    
    func postDidFail(viewController: PostViewController, with error: Error) {
        let alertController = UIAlertController(title: "Foo", message: "Bar", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
