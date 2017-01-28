//  Created by dasdom on 28/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

protocol LoginViewProtocol {
    var username: String? { get }
    var password: String? { get }
}

class LoginView: UIView {

    let usernameTextField: UITextField
    let passwordTextField: UITextField
    let loginButton: UIButton
    
    override init(frame: CGRect) {
        
        usernameTextField = UITextField()
        
        passwordTextField = UITextField()
        passwordTextField.isSecureTextEntry = true
        
        loginButton = UIButton(type: .system)
        
        super.init(frame: frame)
        
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LoginView: LoginViewProtocol {
    var username: String? {
        return usernameTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
}
