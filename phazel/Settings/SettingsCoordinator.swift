//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorDelegate: class {
    func settingsDidFinish(coordinator: SettingsCoordinator)
}

final class SettingsCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
    fileprivate let userDefaults: UserDefaults
    var childViewControllers = [UIViewController]()
    weak var delegate: SettingsCoordinatorDelegate?
    let navigationController: UINavigationController

    init(window: UIWindow, userDefaults: UserDefaults) {
        self.window = window
        self.userDefaults = userDefaults
        navigationController = UINavigationController()
    }
    
    func start() {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        childViewControllers.append(settingsViewController)
        navigationController.viewControllers = [settingsViewController]
        
        window.visibleViewController?.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - SettingsViewControllerDelegate
extension SettingsCoordinator: SettingsViewControllerDelegate {
    func didSetSettingsFor<T>(key: String, withValue: T?) {
        
    }
}
