//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class MainCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
//    private let apiClient: APIClientProtocol
    var childCoordinators: [CoodinatorProtocol] = []
    
    init(window: UIWindow) {
        self.window = window
//        self.apiClient = apiClient
    }
    
    func start() {
        let postCoordinator = PostCoordinator(window: window)
        childCoordinators.append(postCoordinator)
        postCoordinator.start()
        
        window.makeKeyAndVisible()
        
//        if !apiClient.isLoggedIn() {
//            let loginCoordinator = LoginCoordinator(window: window)
//            childCoordinators.append(loginCoordinator)
//            loginCoordinator.start()
//        }
    }
}

protocol CoodinatorProtocol {
    func start()
}
