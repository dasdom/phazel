//  Created by dasdom on 05/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class SettingsCoordinatorTests: XCTestCase {
    
    var sut: SettingsCoordinator!
    var window: UIWindow!
    let userDefaults = UserDefaults()
    
    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        sut = SettingsCoordinator(window: window, userDefaults: userDefaults)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        
        super.tearDown()
    }
    
    func test_start_setsDelegateOfViewController() {
        sut.start()
        
        guard let viewController = window.visibleViewController as? SettingsViewController else { return XCTFail() }
        XCTAssertTrue(viewController.delegate is SettingsCoordinator)
    }
    
    func test_start_setsSettingsItemsOfViewController() {
        userDefaults.set("dasdom", forKey: UserDefaultsKey.username.rawValue)
        sut.start()
        
        guard let viewController = window.visibleViewController as? SettingsViewController else { return XCTFail() }
        guard let settingsItem = viewController.settingsItems.first else { return XCTFail() }
        guard case .string(let title, let value) = settingsItem else { return XCTFail() }
        XCTAssertEqual(title, "Account")
        XCTAssertEqual(value, "dasdom")
    }
}

// MARK: - Change Account
extension SettingsCoordinatorTests {
    func test_didSelect_pushesAccountList() {
        let navigationController = NavigationControllerMock(rootViewController: UIViewController())
        let accounts = [["id": "23", "username": "foo"], ["id": "42", "username": "bar"]]
        let userDefaults = UserDefaults()
        userDefaults.set(accounts, forKey: "accounts")
        let settingsItem = SettingsItem.string("Account", "foo")
        let localSUT = SettingsCoordinator(window: UIWindow(), userDefaults: userDefaults, navigationController: navigationController)
        
        localSUT.didSelect(SettingsViewController(settingsItems: [settingsItem]), settingsItem: settingsItem)
        
        guard let viewController = navigationController.pushedViewController as? AccountsViewController else { return XCTFail() }
        let expectedAccounts = [LoginUser(id: "23", username: "foo"), LoginUser(id: "42", username: "bar")]
        XCTAssertEqual(viewController.accounts, expectedAccounts)
    }
    
    func test_didSelect_setsDelegateOfAccountsViewController() {
        let navigationController = NavigationControllerMock(rootViewController: UIViewController())
        let accounts = [["id": "23", "username": "foo"]]
        let userDefaults = UserDefaults()
        userDefaults.set(accounts, forKey: "accounts")
        let settingsItem = SettingsItem.string("Account", "foo")
        let localSUT = SettingsCoordinator(window: UIWindow(), userDefaults: userDefaults, navigationController: navigationController)
        
        localSUT.didSelect(SettingsViewController(settingsItems: [settingsItem]), settingsItem: settingsItem)
        
        guard let viewController = navigationController.pushedViewController as? AccountsViewController else { return XCTFail() }
        XCTAssertTrue(viewController.delegate is SettingsCoordinator)
    }
    
    func test_didSelect_changesUsername() {
        let userDefaults = UserDefaults()
        userDefaults.set("Foo", forKey: "username")
        let localSUT = SettingsCoordinator(window: UIWindow(), userDefaults: userDefaults)
        
        localSUT.didSelect(AccountsViewController(accounts: []), account: Account(id: "42", username: "Bar"))
        
        XCTAssertEqual(userDefaults.value(forKey: "username") as? String, "Bar")
    }
    
    func test_didSelect_popsViewController() {
        let navigationController = NavigationControllerMock(rootViewController: UIViewController())
        let localSUT = SettingsCoordinator(window: UIWindow(), userDefaults: UserDefaults(), navigationController: navigationController)
        
        localSUT.didSelect(AccountsViewController(accounts: []), account: Account(id: "42", username: "Bar"))
        
        XCTAssertTrue(navigationController.didPop)
    }
    
//    func test_didSelect_removesAccountsViewController_fromChildViewControllers() {
//        let navigationController = NavigationControllerMock(rootViewController: UIViewController())
//        let localSUT = SettingsCoordinator(window: UIWindow(), userDefaults: UserDefaults(), navigationController: navigationController)
//        let accountsViewController = AccountsViewController(accounts: [])
//        localSUT.childViewControllers.append(accountsViewController)
//        
//        localSUT.didSelect(accountsViewController, account: Account(id: "42", username: "Bar"))
//        
//        XCTAssertFalse(localSUT.childViewControllers.last is AccountsViewController)
//    }
}

// MARK: - Add New Account
extension SettingsCoordinatorTests {
    func test_addAccount_showsLogin() {

        sut.addAccount(AccountsViewController(accounts: []))
        
        XCTAssertTrue(window.visibleViewController is LoginViewController)
    }
    
    func test_addAccount_setsDelegate_ofLoginCoordinator() {
        
        sut.addAccount(AccountsViewController(accounts: []))
        
        guard let coordinator = sut.childCoordinators.last as? LoginCoordinator else { return XCTFail() }
        XCTAssertTrue(coordinator.delegate is SettingsCoordinator)
    }
    
    func test_coordinatorDidLogin_removesCoordinator() {
        let loginCoordinator = LoginCoordinator(window: window, apiClient: APIClient(userDefaults: UserDefaults()))
        sut.childCoordinators.append(loginCoordinator)
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.coordinatorDidLogin(coordinator: loginCoordinator, with: loginUser)
        
        XCTAssertEqual(sut.childCoordinators.count, 0)
    }
    
    func test_accountsViewController_addsAccount_afterLogin() {
        let loginCoordinator = LoginCoordinator(window: window, apiClient: APIClient(userDefaults: UserDefaults()))
        let accountsViewController = AccountsViewController(accounts: [])
        sut.childViewControllers.append(accountsViewController)
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.coordinatorDidLogin(coordinator: loginCoordinator, with: loginUser)

        XCTAssertEqual(accountsViewController.accounts.first, loginUser)
    }
}

// MARK: - Mocks
extension SettingsCoordinatorTests {
    class NavigationControllerMock: UINavigationController {
        
        var pushedViewController: UIViewController?
        var didPop = false
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
        
        override func popViewController(animated: Bool) -> UIViewController? {
            didPop = true
            return super.popViewController(animated: animated)
        }
    }
}
