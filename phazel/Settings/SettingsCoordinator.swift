//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol SettingsCoordinatorDelegate: class {
    func settingsDidFinish(coordinator: SettingsCoordinator)
}

final class SettingsCoordinator: NavigationCoordinating {
    
    let rootViewController: UINavigationController
    var viewController: SettingsViewController?
    fileprivate let userDefaults: UserDefaults
    var loginCoordinator: LoginCoordinator?
    var accountsCoordinator: AccountsCoordinator?
    weak var delegate: SettingsCoordinatorDelegate?

    init(rootViewController: UINavigationController, userDefaults: UserDefaults) {
        self.rootViewController = rootViewController
        self.userDefaults = userDefaults
    }
    
//    func start() {
//        
//        let settingsViewController = SettingsViewController(settingsItems: settingsItems)
//        settingsViewController.delegate = self
//        childViewControllers.append(settingsViewController)
//        navigationController.viewControllers = [settingsViewController]
//        
//        window.visibleViewController?.present(navigationController, animated: true, completion: nil)
//    }

    func createViewController() -> SettingsViewController {
        return SettingsViewController(settingsItems: settingsItems)
    }
    
    func config(_ viewController: SettingsViewController) {
        viewController.delegate = self
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
    func didSelect(_ viewController: SettingsViewController, settingsItem: SettingsItem) {
    
        let accounstsKey = UserDefaultsKey.accounts.rawValue
        guard let rawAccounts = userDefaults.value(forKey: accounstsKey) as? [[String:String]] else { return }
        let accounts = accountsFrom(rawAccounts: rawAccounts)
        
        accountsCoordinator = AccountsCoordinator(rootViewController: rootViewController, accounts: accounts, userDefaults: userDefaults)
        accountsCoordinator?.start()
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

// MARK: - LoginCoordinatorDelegate
//extension SettingsCoordinator: LoginCoordinatorDelegate {
//    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
//        
////        if let accountsViewController = childViewControllers.last as? AccountsViewController {
////            accountsViewController.append(account: loginUser)
////        }
//    }
//}
