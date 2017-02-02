//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import UIKit

final class LoginCoordinator: LoginViewControllerDelegate {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func loginDidSucceed(with loginUser: LoginUser) {
        
    }
    
    func loginDidFail(with error: Error) {
        
        let alertController = UIAlertController(title: "Foo", message: "Bar", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        window.visibleViewController?.present(alertController, animated: true, completion: nil)
    }
}
