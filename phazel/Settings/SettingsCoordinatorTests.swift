//  Created by dasdom on 05/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class SettingsCoordinatorTests: XCTestCase {
    
    var sut: SettingsCoordinator!
    let userDefaults = UserDefaults()
    
    override func setUp() {
        super.setUp()

        sut = SettingsCoordinator(rootViewController: UINavigationController(), userDefaults: userDefaults)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_start_setsDelegateOfViewController() {
        sut.start()
        
        XCTAssertNotNil(sut.viewController)
    }
    
    func test_start_setsSettingsItemsOfViewController() {
        userDefaults.set("dasdom", forKey: UserDefaultsKey.username.rawValue)
        sut.start()
        
        guard let viewController = sut.viewController else { return XCTFail() }
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
        let localSUT = SettingsCoordinator(rootViewController: navigationController, userDefaults: userDefaults)
        localSUT.didSelect(SettingsViewController(settingsItems: [settingsItem]), settingsItem: settingsItem)
        
        guard let viewController = navigationController.pushedViewController as? AccountsViewController else { return XCTFail() }
        let expectedAccounts = [LoginUser(id: "23", username: "foo"), LoginUser(id: "42", username: "bar")]
        XCTAssertEqual(viewController.accounts, expectedAccounts)
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
    
//    func test_accountsViewController_addsAccount_afterLogin() {
//        let loginCoordinator = LoginCoordinator(rootViewController: UIViewController(), apiClient: APIClient(userDefaults: UserDefaults()))
//        let accountsViewController = AccountsViewController(accounts: [])
//        sut.childViewControllers.append(accountsViewController)
//        
//        let loginUser = LoginUser(id: "42", username: "foo")
//        sut.coordinatorDidLogin(coordinator: loginCoordinator, with: loginUser)
//
//        XCTAssertEqual(accountsViewController.accounts.first, loginUser)
//    }
}
