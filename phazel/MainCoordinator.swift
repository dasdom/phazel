//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class MainCoordinator: CoodinatorProtocol, LoginCoordinatorDelegate {
    
    private let window: UIWindow
    var childCoordinators: [CoodinatorProtocol] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let postCoordinator = PostCoordinator(window: window)
        childCoordinators.append(postCoordinator)
        postCoordinator.start()
        
        let loginCoordinator = LoginCoordinator(window: window)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
        
    }
}

protocol CoodinatorProtocol {
    func start()
}
