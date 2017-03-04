//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorDelegate: class {
    func settingsDidFinish(coordinator: SettingsCoordinator)
}

final class SettingsCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
    var childViewControllers = [UIViewController]()
    weak var delegate: SettingsCoordinatorDelegate?
    let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }
    
    func start() {
        let settingsViewController = SettingsViewController()
        navigationController.viewControllers = [settingsViewController]
        
        window.visibleViewController?.present(navigationController, animated: true, completion: nil)
    }
}
