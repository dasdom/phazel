//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import UIKit
import Roaster

protocol LoginCoordinatorDelegate {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser)
}

final class LoginCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
    var childViewControllers = [UIViewController]()
    var delegate: LoginCoordinatorDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let loginViewController = LoginViewController(contentView: LoginView())
        loginViewController.delegate = self
        childViewControllers.append(loginViewController)
        
        window.visibleViewController?.present(loginViewController, animated: true, completion: nil)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func loginDidSucceed(viewController: LoginViewController, with loginUser: LoginUser) {
        
        viewController.dismiss(animated: true, completion: nil)
        delegate?.coordinatorDidLogin(coordinator: self, with: loginUser)
        
        if let index = childViewControllers.index(where: { $0 == viewController }) {
            childViewControllers.remove(at: index)
        }
    }
    
    func loginDidFail(viewController: LoginViewController, with error: Error) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
