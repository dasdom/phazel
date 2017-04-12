//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class AccountsCoordinatorTests: XCTestCase {
    
    var sut: AccountsCoordinator!
    
    override func setUp() {
        super.setUp()

        sut = AccountsCoordinator(rootViewController: UINavigationController(), accounts: [], userDefaults: UserDefaults())
    }
    
    override func tearDown() {
        sut.stop()
        sut = nil
        
        super.tearDown()
    }
    
    func test_addAccount_showsLogin() {
        
        sut.addAccount(AccountsViewController(accounts: []))
        
        XCTAssertNotNil(sut.loginCoordinator?.viewController)
    }
    
    func test_addAccount_setsDelegate() {
        
        sut.addAccount(AccountsViewController(accounts: []))

        XCTAssertTrue(sut.loginCoordinator?.delegate is AccountsCoordinator)
    }
    
    func test_didSelect_changesUsername() {
        let userDefaults = UserDefaults()
        userDefaults.set("Foo", forKey: "username")
        let localSUT = AccountsCoordinator(rootViewController: UINavigationController(), accounts: [], userDefaults: userDefaults)
        
        localSUT.didSelect(AccountsViewController(accounts: []), account: Account(id: "42", username: "Bar"))
        
        XCTAssertEqual(userDefaults.value(forKey: "username") as? String, "Bar")
    }
    
    func test_didSelect_popsViewController() {
        let navigationController = NavigationControllerMock(rootViewController: UIViewController())
        let localSUT = AccountsCoordinator(rootViewController: navigationController, accounts: [], userDefaults: UserDefaults())
        
        localSUT.didSelect(AccountsViewController(accounts: []), account: Account(id: "42", username: "Bar"))
        
        XCTAssertTrue(navigationController.didPop)
    }
    
    func test_coordinatorDidLogin_removesCoordinator() {
        let apiClient = APIClient(userDefaults: UserDefaults())
        let loginCoordinator = LoginCoordinator(rootViewController: UIViewController(), apiClient: apiClient)
        let mockLoginViewController = MockLoginViewController(contentView: LoginView(), apiClient: apiClient)
        loginCoordinator.viewController = mockLoginViewController
        sut.loginCoordinator = loginCoordinator
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.coordinatorDidLogin(coordinator: loginCoordinator, with: loginUser)
        
        XCTAssertTrue(mockLoginViewController.didDismiss)
    }
    
    func test_coordinatorDidLogin_addsAccount() {
        sut.start()
        let apiClient = APIClient(userDefaults: UserDefaults())
        let loginCoordinator = LoginCoordinator(rootViewController: UIViewController(), apiClient: apiClient)
//        let mockLoginViewController = MockLoginViewController(contentView: LoginView(), apiClient: apiClient)
//        loginCoordinator.viewController = mockLoginViewController
        sut.loginCoordinator = loginCoordinator
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.coordinatorDidLogin(coordinator: loginCoordinator, with: loginUser)
        
        XCTAssertEqual(sut.viewController?.accounts.first, loginUser)
    }
}

extension AccountsCoordinatorTests {
    class MockLoginViewController: LoginViewController {
        
        var didDismiss = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            didDismiss = true
            completion?()
        }
    }
}
