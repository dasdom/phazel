//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class AccountsCoordinator: NavigationCoordinating {
    
    let rootViewController: UINavigationController
    var viewController: AccountsViewController?
    let accounts: [Account]
    let userDefaults: UserDefaults
    var loginCoordinator: LoginCoordinator?
    
    init(rootViewController: UINavigationController, accounts: [Account], userDefaults: UserDefaults) {
        self.rootViewController = rootViewController
        self.accounts = accounts
        self.userDefaults = userDefaults
    }
    
    func createViewController() -> AccountsViewController {
        return AccountsViewController(accounts: accounts)
    }
    
    func config(_ viewController: AccountsViewController) {
        
    }
}

extension AccountsCoordinator: AccountsViewControllerDelegate {
    
    func didSelect(_ viewController: AccountsViewController, account: Account) {
        userDefaults.set(account.username, forKey: UserDefaultsKey.username.rawValue)
        rootViewController.popViewController(animated: true)
        self.viewController = nil
    }
    
    func addAccount(_ viewController: AccountsViewController) {
        loginCoordinator = LoginCoordinator(rootViewController: viewController, apiClient: APIClient(userDefaults: userDefaults))
        loginCoordinator?.delegate = self
        loginCoordinator?.start()        
    }
}

extension AccountsCoordinator: LoginCoordinatorDelegate {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
        
        coordinator.stop()
        viewController?.append(account: loginUser)
    }
}
