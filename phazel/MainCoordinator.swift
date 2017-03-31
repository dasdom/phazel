//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class MainCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
    private let apiClient: APIClientProtocol
    var childCoordinators: [CoodinatorProtocol] = []
    var userDefaults = UserDefaults(suiteName: "group.com.swiftandpainless.phazel")!
    
    init(window: UIWindow) {
        self.window = window
        self.apiClient = APIClient(userDefaults: userDefaults)
    }
    
    func start() {
        let postCoordinator = PostCoordinator(window: window, apiClient: apiClient, userDefaults: userDefaults)
        childCoordinators.append(postCoordinator)
        postCoordinator.start()
        
        window.makeKeyAndVisible()
    }
}

protocol CoodinatorProtocol {
    func start()
}
