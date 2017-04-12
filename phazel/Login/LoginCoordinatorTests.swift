//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class LoginCoordinatorTests: XCTestCase {
    
    var sut: LoginCoordinator!
    var window: UIWindow!
    let apiClient = APIClient(userDefaults: UserDefaults())
    
    override func setUp() {
        super.setUp()

        sut = LoginCoordinator(rootViewController: UIViewController(), apiClient: apiClient)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        
        super.tearDown()
    }
    
    func test_start_setsLoginViewController_asVisibleController() {
        sut.start()
        
        XCTAssertNotNil(sut.viewController)
    }
    
    func test_start_setsDelegateOfViewController() {
        sut.start()
        
        XCTAssertTrue(sut.viewController?.delegate is LoginCoordinator)
    }

    func test_failure_PresentsAlertViewController() {
        let mockLoginViewController = MockLoginViewController(contentView: LoginView(), apiClient: apiClient)
        
        sut.loginDidFail(viewController: mockLoginViewController, with: NSError(domain: "Foo", code: 42, userInfo: nil))
        
        XCTAssertTrue(mockLoginViewController.inTestPresentedViewController is UIAlertController)
    }
    
    func test_success_setsUser() {
        let mockLoginViewController = MockLoginViewController(contentView: LoginView(), apiClient: apiClient)
        let coordinatorDelegate = MockLoginCoordinatorDelegate()
        sut.delegate = coordinatorDelegate
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.loginDidSucceed(viewController: mockLoginViewController, with: loginUser)
        
        XCTAssertEqual(coordinatorDelegate.loginUser, loginUser)
    }
}

extension LoginCoordinatorTests {
    
    class MockLoginViewController: LoginViewController {
        
        var inTestPresentedViewController: UIViewController?
        var didDismiss = false
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            inTestPresentedViewController = viewControllerToPresent
        }
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            didDismiss = true
            completion?()
        }
    }
    
    class MockLoginCoordinatorDelegate: LoginCoordinatorDelegate {
        
        var loginUser: LoginUser?
        
        func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
            self.loginUser = loginUser
        }
    }
}
