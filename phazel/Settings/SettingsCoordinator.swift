//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol SettingsCoordinatorDelegate: class {
    func settingsDidFinish(coordinator: SettingsCoordinator)
}

final class SettingsCoordinator: CoodinatorProtocol {
    
    private let window: UIWindow
    fileprivate let userDefaults: UserDefaults
    var childViewControllers = [UIViewController]()
    weak var delegate: SettingsCoordinatorDelegate?
    let navigationController: UINavigationController

    init(window: UIWindow, userDefaults: UserDefaults, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.userDefaults = userDefaults
        self.navigationController = navigationController
    }
    
    func start() {
        var settingsItems: [SettingsItem] = []
        if let username = userDefaults.value(forKey: UserDefaultsKey.username.rawValue) as? String {
            let settingsItem = SettingsItem.string("Account", username)
            settingsItems.append(settingsItem)
        }
        let settingsViewController = SettingsViewController(settingsItems: settingsItems)
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
    
    func didSelect(rowAt: IndexPath) {
        guard let accountsArray = userDefaults.value(forKey: UserDefaultsKey.accounts.rawValue) as? [[String:String]] else { return }
        var accounts: [LoginUser] = []
        for dictionary in accountsArray {
            if let id = dictionary[DictionaryKey.id.rawValue], let username = dictionary[DictionaryKey.username.rawValue] {
                accounts.append(LoginUser(id: id, username: username))
            }
        }
        navigationController.pushViewController(AccountsViewController(accounts: accounts), animated: true)
        
    }
}
