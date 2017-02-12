//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class MainCoordinator: LoginCoordinatorDelegate {
    
    private let window: UIWindow
    private let tabBarController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        tabBarController = UITabBarController()
    }
    
    func start() {
        window.rootViewController = tabBarController
    }
    
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
        
    }
}
