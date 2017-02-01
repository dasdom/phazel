//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class LoginCoordinatorTests: XCTestCase {
    
    var sut: LoginCoordinator!
    var mockRootViewController: MockViewController!
    var mockNavigationController: MockNavigationController!
    
    override func setUp() {
        super.setUp()

        mockRootViewController = MockViewController()
        mockNavigationController = MockNavigationController(rootViewController: mockRootViewController)
        sut = LoginCoordinator(navigationController: mockNavigationController)
    }
    
    override func tearDown() {

        sut = nil
        super.tearDown()
    }
    
    func test_isLoginViewControllerDelegate() {
        XCTAssertTrue(sut is LoginViewControllerDelegate)
    }
    
    func test_failurePresents_AlertViewController() {
        
        sut.loginDidFail(with: NSError(domain: "Foo", code: 42, userInfo: nil))
        
        XCTAssertTrue(mockRootViewController.inTestPresentedViewController is UIAlertController)
    }
}

extension LoginCoordinatorTests {
//    class MockNavigationController: UINavigationController {
//        
//        var inTestPresentedViewController: UIViewController?
//        
//        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//            inTestPresentedViewController = viewControllerToPresent
//        }
//    }
    
    class MockViewController: UIViewController {
        
        var inTestPresentedViewController: UIViewController?
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            inTestPresentedViewController = viewControllerToPresent
        }
    }
}
