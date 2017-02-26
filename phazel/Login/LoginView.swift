//  Created by dasdom on 28/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

final class LoginView: DDHView {

    let usernameTextField: DDHTextField
    let passwordTextField: DDHTextField
    let loginButton: DDHButton
    fileprivate let spinner: UIActivityIndicatorView
    fileprivate let loginButtonTitle = "Login"
    
    override init(frame: CGRect) {
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Please log in with\nyour pnut.io account"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        
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
        loginButton.setTitle(loginButtonTitle, for: .normal)
        loginButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.buttonBackground
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
//        spinner.startAnimating()
        
        loginButton.addSubview(spinner)
        
        let stackView = UIStackView(arrangedSubviews: [label, usernameTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.background
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        addSubview(stackView)

        let views = ["stackView": stackView]
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-[stackView]-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[stackView]", options: [], metrics: nil, views: views)
        layoutConstraints += [usernameTextField.heightAnchor.constraint(equalToConstant: 30)]
        layoutConstraints += [passwordTextField.heightAnchor.constraint(equalToConstant: 30)]
        layoutConstraints += [spinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor)]
        layoutConstraints += [spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = textField.text as NSString?
        let finalString = nsString?.replacingCharacters(in: range, with: string)
        
        if textField == usernameTextField {
            if let username = finalString,
                username.characters.count > 0,
                let password = passwordTextField.text,
                password.characters.count > 0 {
                
                loginButton.isEnabled = true
            } else {
                loginButton.isEnabled = false
            }
        } else if textField == passwordTextField {
            if let username = usernameTextField.text,
                username.characters.count > 0,
                let password = finalString,
                password.characters.count > 0 {
                
                loginButton.isEnabled = true
            } else {
                loginButton.isEnabled = false
            }
        }
        
        return true
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
    
    func set(animating: Bool) {
        if animating {
            loginButton.setTitle(nil, for: .normal)
            spinner.startAnimating()
        } else {
            loginButton.setTitle(loginButtonTitle, for: .normal)
            spinner.stopAnimating()
        }
    }
}

protocol LoginViewProtocol {
    var username: String? { get }
    var password: String? { get }
    func setFirstResponder()
    func set(animating: Bool)
}

@objc protocol LoginProtocol {
    @objc func login()
}

fileprivate extension Selector {
    static let login = #selector(LoginProtocol.login)
}
