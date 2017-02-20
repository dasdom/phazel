//  Created by dasdom on 28/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

final class LoginView: DDHView {

    let usernameTextField: DDHTextField
    let passwordTextField: DDHTextField
    let loginButton: DDHButton
    
    override init(frame: CGRect) {
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Please log in"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        
        usernameTextField = DDHTextField()
        usernameTextField.font = UIFont.preferredFont(forTextStyle: .body)
        usernameTextField.placeholder = "Username"
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        
        passwordTextField = DDHTextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont.preferredFont(forTextStyle: .body)
        passwordTextField.placeholder = "Password"

        loginButton = DDHButton(type: .system)
        loginButton.addTarget(nil, action: .login, for: .touchUpInside)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.buttonBackground
        
        let stackView = UIStackView(arrangedSubviews: [label, usernameTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.background
        
        addSubview(stackView)

        let views = ["stackView": stackView]
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-[stackView]-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[stackView]", options: [], metrics: nil, views: views)
        layoutConstraints += [usernameTextField.heightAnchor.constraint(equalToConstant: 30)]
        layoutConstraints += [passwordTextField.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(layoutConstraints)
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
    
    func setFirstResponder() {
        usernameTextField.becomeFirstResponder()
    }
}

protocol LoginViewProtocol {
    var username: String? { get }
    var password: String? { get }
    func setFirstResponder()
}

@objc protocol LoginProtocol {
    @objc func login()
}

fileprivate extension Selector {
    static let login = #selector(LoginProtocol.login)
}
