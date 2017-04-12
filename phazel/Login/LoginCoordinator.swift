//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import UIKit
import Roaster

protocol LoginCoordinatorDelegate: class {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser)
}

class LoginCoordinator: Coordinating {
    
    let rootViewController: UIViewController
    var viewController: LoginViewController?
    weak var delegate: LoginCoordinatorDelegate?
    let apiClient: APIClientProtocol
    
    init(rootViewController: UIViewController, apiClient: APIClientProtocol) {
        self.rootViewController = rootViewController
        self.apiClient = apiClient
    }
    
    func createViewController() -> LoginViewController {
        return LoginViewController(contentView: LoginView(), apiClient: apiClient)
    }
    
    func config(_ viewController: LoginViewController) {
        viewController.delegate = self
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func loginDidSucceed(viewController: LoginViewController, with loginUser: LoginUser) {
        
        delegate?.coordinatorDidLogin(coordinator: self, with: loginUser)
    }
    
    func loginDidFail(viewController: LoginViewController, with error: Error) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
