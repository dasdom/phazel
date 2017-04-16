//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster
import CoreData

final class MainCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let apiClient: APIClientProtocol
    private let persistentContainer: NSPersistentContainer
    var timelineCoordinator: PostsCoordinator?
    var userDefaults = UserDefaults(suiteName: "group.com.swiftandpainless.phazel")!
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        apiClient = APIClient(userDefaults: userDefaults)
        
        persistentContainer = NSPersistentContainer(name: "Roaster")
        persistentContainer.loadPersistentStores { _, error in
            print("Error: \(String(describing: error))")
        }
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        timelineCoordinator = PostsCoordinator(rootViewController: navigationController, apiClient: apiClient, userDefaults: userDefaults, persistentContainer: persistentContainer)
        timelineCoordinator?.start()
    }
}

protocol CoodinatorProtocol {
    func start()
}
