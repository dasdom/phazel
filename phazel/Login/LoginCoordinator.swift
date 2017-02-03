//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser)
}

final class LoginCoordinator: LoginViewControllerDelegate {
    
    private let window: UIWindow
    var childViewControllers = [UIViewController]()
    var delegate: LoginCoordinatorDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let loginViewController = LoginViewController(contentView: LoginView())
        childViewControllers.append(loginViewController)
        window.visibleViewController?.present(loginViewController, animated: true, completion: nil)
    }
    
    func loginDidSucceed(viewController: LoginViewController, with loginUser: LoginUser) {
        
        viewController.dismiss(animated: true, completion: nil)
        delegate?.coordinatorDidLogin(coordinator: self, with: loginUser)
    }
    
    func loginDidFail(viewController: LoginViewController, with error: Error) {
        
        let alertController = UIAlertController(title: "Foo", message: "Bar", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
