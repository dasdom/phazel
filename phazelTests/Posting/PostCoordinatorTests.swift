//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class PostCoordinatorTests: XCTestCase {
    
    var sut: PostCoordinator!
    var window: UIWindow!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        apiClient = MockAPIClient()
        sut = PostCoordinator(window: window, apiClient: apiClient)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        apiClient = nil
        
        super.tearDown()
    }
}

// MARK: - Posting
extension PostCoordinatorTests {
    func test_start_setsPostViewController_asRoot() {
        sut.start()
        
        XCTAssertTrue(window.rootViewController is UINavigationController)
        XCTAssertEqual(sut.childViewControllers.count, 1)
    }
    
    func test_start_setsDelegate() {
        sut.start()
        guard let viewController = sut.childViewControllers.last as? PostViewController else { return XCTFail() }

        XCTAssertTrue(viewController.delegate is PostCoordinator)
    }
    
    func test_postDidFail_showsAlert() {
        let mockViewController = MockPostViewController(contentView: PostView())
        
        sut.postDidFail(viewController: mockViewController, with: NSError(domain: "Foo", code: 42, userInfo: nil))

        XCTAssertTrue(mockViewController.inTestPresentedViewController is UIAlertController)
    }
}

// MARK: - Login
extension PostCoordinatorTests {
    func test_viewDidLoad_showsLogin_ifNotLoggedIn() {
        sut.start()
        apiClient._isLoggedIn = false
        guard let viewController = sut.childViewControllers.last else { return XCTFail() }
        XCTAssertFalse(window.visibleViewController is LoginViewController)

        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        XCTAssertTrue(window.visibleViewController is LoginViewController)
    }

    func test_viewDidLoad_doesNotShowsLogin_ifLoggedIn() {
        sut.start()
        apiClient._isLoggedIn = true
        guard let viewController = sut.childViewControllers.last else { return XCTFail() }
        
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        XCTAssertFalse(window.visibleViewController is LoginViewController)
    }
    
    func test_viewDidLoad_setsDeleate_ofLoginCoordinator() {
        sut.start()
        apiClient._isLoggedIn = false
        guard let viewController = sut.childViewControllers.last else { return XCTFail() }
        XCTAssertFalse(window.visibleViewController is LoginViewController)
        
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        guard let coordinator = sut.childCoordinators.last as? LoginCoordinator else { return XCTFail() }
        XCTAssertTrue(coordinator.delegate is PostCoordinator)
    }
    
    func test_coordinatorDidLogin_removesCoordinator() {
        let loginCoordinator = LoginCoordinator(window: window)
        sut.childCoordinators.append(loginCoordinator)
        
        let loginUser = LoginUser(id: "42", username: "foo")
        sut.coordinatorDidLogin(coordinator: loginCoordinator, with: loginUser)
        
        XCTAssertEqual(sut.childCoordinators.count, 0)
    }
}

// MARK: - Settings
extension PostCoordinatorTests {
    func test_showInfo_presentsSettingsViewController() {
        sut.start()
        let mockViewController = MockPostViewController(contentView: PostView())

        sut.showInfo(viewController: mockViewController)
        
        XCTAssertTrue(window.visibleViewController is SettingsViewController)
    }
    
    func test_showInfo_setsDelegate_ofSettingsCoordinator() {
        sut.start()
        let mockViewController = MockPostViewController(contentView: PostView())
        
        sut.showInfo(viewController: mockViewController)
        
        guard let coordinator = sut.childCoordinators.last as? SettingsCoordinator else { return XCTFail() }
        XCTAssertTrue(coordinator.delegate is PostCoordinator)
    }
}

//---------------------------------------------------------------------
// MARK: - Mocks
extension PostCoordinatorTests {
    
    class MockPostViewController: PostViewController {
        
        var inTestPresentedViewController: UIViewController?

        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            inTestPresentedViewController = viewControllerToPresent
        }
    }
    
    class MockAPIClient: APIClientProtocol {
        
        var _isLoggedIn = false
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        }
        
        func post(text: String, completion: @escaping (Result<String>) -> ()) {
        }
        
        func isLoggedIn() -> Bool {
            return self._isLoggedIn
        }
    }
    
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
