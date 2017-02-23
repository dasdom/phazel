//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class LoginCoordinatorTests: XCTestCase {
    
    var sut: LoginCoordinator!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        sut = LoginCoordinator(window: window)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        
        super.tearDown()
    }
    
    func test_start_setsLoginViewController_asVisibleController() {
        sut.start()
        
        XCTAssertTrue(window.visibleViewController is LoginViewController)
        XCTAssertEqual(sut.childViewControllers.count, 1)
    }
    
    func test_start_setsDelegateOfViewController() {
        sut.start()
        
        guard let viewController = sut.childViewControllers.last as? LoginViewController else { return XCTFail() }
        XCTAssertTrue(viewController.delegate is LoginCoordinator)
    }

    func test_failure_PresentsAlertViewController() {
        let mockLoginViewController = MockLoginViewController(contentView: LoginView())
        
        sut.loginDidFail(viewController: mockLoginViewController, with: NSError(domain: "Foo", code: 42, userInfo: nil))
        
        XCTAssertTrue(mockLoginViewController.inTestPresentedViewController is UIAlertController)
    }
    
    func test_success_dismissesController() {
        let mockLoginViewController = MockLoginViewController(contentView: LoginView())
        let coordinatorDelegate = MockLoginCoordinatorDelegate()
        sut.delegate = coordinatorDelegate
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.loginDidSucceed(viewController: mockLoginViewController, with: loginUser)
        
        XCTAssertTrue(mockLoginViewController.didDismiss)
        XCTAssertEqual(coordinatorDelegate.loginUser, loginUser)
    }
    
    func test_success_removesLoginViewController() {
        sut.start()
        guard let loginViewController = window.visibleViewController as? LoginViewController else { return XCTFail() }
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.loginDidSucceed(viewController: loginViewController, with: loginUser)
        
        XCTAssertEqual(sut.childViewControllers.count, 0)
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
