//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import UIKit

final class LoginCoordinator: LoginViewControllerDelegate {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func loginDidSucceed(with loginUser: LoginUser) {
        
    }
    
    func loginDidFail(with error: Error) {
        
        let alertController = UIAlertController(title: "Foo", message: "Bar", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        navigationController.viewControllers.last?.present(alertController, animated: true, completion: nil)
    }
}
