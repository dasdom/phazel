//  Created by dasdom on 30/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let contentView: LoginViewProtocol
    let apiClient: APIClientProtocol
    
    init(contentView: LoginViewProtocol, apiClient: APIClientProtocol = APIClient()) {
        
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
}

extension LoginViewController: LoginProtocol {
    func login() {
        guard let username = contentView.username else { fatalError() }
        guard let password = contentView.password else { fatalError() }
        self.apiClient.login(username: username, password: password) { result in
            
        }
    }
}
