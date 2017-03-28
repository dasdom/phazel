//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol SettingsCoordinatorDelegate: class {
    func settingsDidFinish(coordinator: SettingsCoordinator)
}

final class SettingsCoordinator: CoodinatorProtocol {
    
    fileprivate let window: UIWindow
    fileprivate let userDefaults: UserDefaults
    fileprivate let navigationController: UINavigationController
    var childViewControllers = [UIViewController]()
    var childCoordinators: [CoodinatorProtocol] = []
    weak var delegate: SettingsCoordinatorDelegate?

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
    func didSelect(_ viewController: SettingsViewController, settingsItem: SettingsItem) {
    
        let accounstsKey = UserDefaultsKey.accounts.rawValue
        guard let rawAccounts = userDefaults.value(forKey: accounstsKey) as? [[String:String]] else { return }
        let accounts = accountsFrom(rawAccounts: rawAccounts)
        
        let accountsViewController = AccountsViewController(accounts: accounts)
        accountsViewController.delegate = self
        childViewControllers.append(accountsViewController)
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

// MARK: - AccountsViewControllerDelegate
extension SettingsCoordinator: AccountsViewControllerDelegate {

    func didSelect(_ viewController: AccountsViewController, account: Account) {
        userDefaults.set(account.username, forKey: UserDefaultsKey.username.rawValue)
        navigationController.popViewController(animated: true)
        
        if let index = childViewControllers.index(where: { $0 as AnyObject === viewController as AnyObject }) {
            childViewControllers.remove(at: index)
        }
    }

    func addAccount(_ viewController: AccountsViewController) {
        let loginCoordinator = LoginCoordinator(window: window, apiClient: APIClient(userDefaults: userDefaults))
        loginCoordinator.delegate = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}

// MARK: - LoginCoordinatorDelegate
extension SettingsCoordinator: LoginCoordinatorDelegate {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
        if let index = childCoordinators.index(where: { $0 as AnyObject === coordinator as AnyObject }) {
            childCoordinators.remove(at: index)
        }
        
        if let accountsViewController = childViewControllers.last as? AccountsViewController {
            accountsViewController.append(account: loginUser)
        }
    }
}
