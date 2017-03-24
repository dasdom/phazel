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
        
        let settingsViewController = SettingsViewController(settingsItems: settingsItems)
        settingsViewController.delegate = self
        childViewControllers.append(settingsViewController)
        navigationController.viewControllers = [settingsViewController]
        
        window.visibleViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    private var settingsItems: [SettingsItem] {
        var settingsItems: [SettingsItem] = []
        if let username = userDefaults.value(forKey: UserDefaultsKey.username.rawValue) as? String {
            let settingsItem = SettingsItem.string("Account", username)
            settingsItems.append(settingsItem)
        }
        return settingsItems
    }
}

// MARK: - SettingsViewControllerDelegate
extension SettingsCoordinator: SettingsViewControllerDelegate {
    func didSetSettingsFor<T>(key: String, withValue: T?) {
        
    }
    
    func didSelect(rowAt: IndexPath) {
        
        let accounstsKey = UserDefaultsKey.accounts.rawValue
        guard let rawAccounts = userDefaults.value(forKey: accounstsKey) as? [[String:String]] else { return }
        let accounts = accountsFrom(rawAccounts: rawAccounts)
        
        let accountsViewController = AccountsViewController(accounts: accounts)
        accountsViewController.delegate = self
        navigationController.pushViewController(accountsViewController, animated: true)
    }
    
    private func accountsFrom(rawAccounts: [[String:String]]) -> [Account] {
        var accounts: [Account] = []
        for dictionary in rawAccounts {
            if let id = dictionary[DictionaryKey.id.rawValue], let username = dictionary[DictionaryKey.username.rawValue] {
                accounts.append(LoginUser(id: id, username: username))
            }
        }
        return accounts
    }
}

extension SettingsCoordinator: AccountsViewControllerDelegate {
    func didSelect(_ viewController: AccountsViewController, account: Account) {
        userDefaults.set(account.username, forKey: UserDefaultsKey.username.rawValue)
        navigationController.popViewController(animated: true)
    }
}
