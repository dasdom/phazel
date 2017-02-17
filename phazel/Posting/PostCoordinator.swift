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
