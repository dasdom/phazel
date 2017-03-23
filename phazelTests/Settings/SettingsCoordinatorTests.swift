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
        
        guard let viewController = sut.childViewControllers.last as? SettingsViewController else { return XCTFail() }
        XCTAssertTrue(viewController.delegate is SettingsCoordinator)
    }
    
    func test_start_setsSettingsItemsOfViewController() {
        userDefaults.set("dasdom", forKey: UserDefaultsKey.username.rawValue)
        sut.start()
        
        guard let viewController = sut.childViewControllers.last as? SettingsViewController else { return XCTFail() }
        guard let settingsItem = viewController.settingsItems.first else { return XCTFail() }
        guard case .string(let title, let value) = settingsItem else { return XCTFail() }
        XCTAssertEqual(title, "Account")
        XCTAssertEqual(value, "dasdom")
    }
    
    func test_didSelect_pushesAccountList() {
        let navigationController = NavigationControllerMock(rootViewController: UIViewController())
        let accounts = [["id": "23", "username": "foo"], ["id": "42", "username": "bar"]]
        let userDefaults = UserDefaults()
        userDefaults.set(accounts, forKey: "accounts")
        let localSUT = SettingsCoordinator(window: UIWindow(), userDefaults: userDefaults, navigationController: navigationController)
        
        localSUT.didSelect(rowAt: IndexPath(row: 0, section: 0))
        
        guard let viewController = navigationController.pushedViewController as? AccountsViewController else { return XCTFail() }
        let expectedAccounts = [LoginUser(id: "23", username: "foo"), LoginUser(id: "42", username: "bar")]
        XCTAssertEqual(viewController.accounts, expectedAccounts)
    }
    
    func test_didSelect_setsDelegateOfAccountsViewController() {
        let navigationController = NavigationControllerMock(rootViewController: UIViewController())
        let accounts = [["id": "23", "username": "foo"]]
        let userDefaults = UserDefaults()
        userDefaults.set(accounts, forKey: "accounts")
        let localSUT = SettingsCoordinator(window: UIWindow(), userDefaults: userDefaults, navigationController: navigationController)
        
        localSUT.didSelect(rowAt: IndexPath(row: 0, section: 0))
        
        guard let viewController = navigationController.pushedViewController as? AccountsViewController else { return XCTFail() }
        XCTAssertTrue(viewController.delegate is SettingsCoordinator)
    }
}

// MARK: - Mocks
extension SettingsCoordinatorTests {
    class NavigationControllerMock: UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
