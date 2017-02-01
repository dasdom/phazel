//  Created by dasdom on 28/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class LoginView: DDHView {

    let usernameTextField: DDHTextField
    let passwordTextField: DDHTextField
    let loginButton: DDHButton
    
    override init(frame: CGRect) {
        
        usernameTextField = DDHTextField()
        
        passwordTextField = DDHTextField()
        passwordTextField.isSecureTextEntry = true
        
        loginButton = DDHButton(type: .system)
        loginButton.addTarget(nil, action: .login, for: .touchUpInside)
        
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

protocol LoginViewProtocol {
    var username: String? { get }
    var password: String? { get }
}

@objc protocol LoginProtocol {
    @objc func login()
}

fileprivate extension Selector {
    static let login = #selector(LoginProtocol.login)
}
