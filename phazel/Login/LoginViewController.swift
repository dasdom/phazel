//  Created by dasdom on 30/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol LoginViewControllerDelegate: class {
    func loginDidSucceed(viewController: LoginViewController, with loginUser: LoginUser)
    func loginDidFail(viewController: LoginViewController, with error: Error)
}

class LoginViewController: UIViewController {

    let contentView: LoginViewProtocol
    let apiClient: APIClientProtocol
    weak var delegate: LoginViewControllerDelegate?

    init(contentView: LoginViewProtocol, apiClient: APIClientProtocol) {
        
        self.contentView = contentView
        self.apiClient = apiClient
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        guard let contentView = self.contentView as? UIView else { fatalError() }
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.setFirstResponder()
    }
}

extension LoginViewController: LoginProtocol {
    func login() {
        guard let username = contentView.username else { fatalError() }
        guard let password = contentView.password else { fatalError() }
        contentView.set(animating: true)
        self.apiClient.login(username: username, password: password) { result in
            
            self.contentView.set(animating: false)
            
            switch result {
            case .success(let loginUser):
                self.delegate?.loginDidSucceed(viewController: self, with: loginUser)
            case .failure(let error):
                self.delegate?.loginDidFail(viewController: self, with: error)
            }
        }
    }
}
