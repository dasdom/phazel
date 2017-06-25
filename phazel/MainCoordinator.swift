//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster
import CoreData

final class MainCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
//    private let navigationController: UINavigationController
    private let apiClient: APIClientProtocol
//    private let persistentContainer: NSPersistentContainer
    var postsCoordinator: PostsCoordinator?
    var globalCoordinator: GlobalCoordinator?
    var tabBarController: UITabBarController
    var userDefaults = UserDefaults(suiteName: "group.com.swiftandpainless.phazel")!
    
    init(window: UIWindow) {
        self.window = window
//        navigationController = UINavigationController()
        apiClient = APIClient(userDefaults: userDefaults)
        tabBarController = UITabBarController()
    }
    
    func start() {
        let postsNavigationController = UINavigationController()
        postsNavigationController.hidesBarsOnSwipe = true
        postsNavigationController.tabBarItem.image = UIImage(named: "timeline")
        postsCoordinator = PostsCoordinator(rootViewController: postsNavigationController, apiClient: apiClient, userDefaults: userDefaults)
        postsCoordinator?.start()
        
        let globalNavigationController = UINavigationController()
        globalNavigationController.hidesBarsOnSwipe = true
        globalNavigationController.tabBarItem.image = UIImage(named: "global")
        globalCoordinator = GlobalCoordinator(rootViewController: globalNavigationController, apiClient: apiClient, userDefaults: userDefaults)
        globalCoordinator?.start()
        
        tabBarController.viewControllers = [postsNavigationController, globalNavigationController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

protocol CoodinatorProtocol {
    func start()
}
