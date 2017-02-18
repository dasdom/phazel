//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class MainCoordinator: CoodinatorProtocol, LoginCoordinatorDelegate {
    
    private let window: UIWindow
    private let apiClient: APIClientProtocol
    var childCoordinators: [CoodinatorProtocol] = []
    
    init(window: UIWindow, apiClient: APIClientProtocol = APIClient()) {
        self.window = window
        self.apiClient = apiClient
    }
    
    func start() {
        let postCoordinator = PostCoordinator(window: window)
        childCoordinators.append(postCoordinator)
        postCoordinator.start()
        
        if !apiClient.isLoggedIn() {
            let loginCoordinator = LoginCoordinator(window: window)
            childCoordinators.append(loginCoordinator)
            loginCoordinator.start()
        }
    }
    
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
    }
}

protocol CoodinatorProtocol {
    func start()
}
