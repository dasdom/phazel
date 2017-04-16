//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
import CoreData
@testable import phazel

class PostsCoordinatorTests: XCTestCase {
    
    var sut: PostsCoordinator!
    var window: UIWindow!
    var apiClient: MockAPIClient!
    let userDefaults = UserDefaults()
    var container: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, error in
            
        }
        
        apiClient = MockAPIClient()
        sut = PostsCoordinator(rootViewController: UINavigationController(), apiClient: apiClient, userDefaults: userDefaults, persistentContainer: container)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        apiClient = nil
        container = nil
        
        super.tearDown()
    }
}

// MARK: - Posting
extension PostsCoordinatorTests {
//    func test_start_setsPostViewController_asRoot() {
//        sut.start()
//        
//        XCTAssertTrue(window.rootViewController is UINavigationController)
//    }
    
    func test_start_setsDelegate() {
        sut.start()
        guard let viewController = sut.viewController else { return XCTFail() }

        XCTAssertTrue(viewController.delegate is PostsCoordinator)
    }
    
    func test_postDidFail_showsAlert() {
        let mockViewController = MockPostViewController(contentView: PostView(), apiClient: MockAPIClient())
        
        sut.postDidFail(viewController: mockViewController, with: NSError(domain: "Foo", code: 42, userInfo: nil))

        XCTAssertTrue(mockViewController.inTestPresentedViewController is UIAlertController)
    }
}

// MARK: - Login
extension PostsCoordinatorTests {
    func test_viewDidLoad_showsLogin_ifNotLoggedIn() {
        sut.start()
        apiClient._isLoggedIn = false

        guard let viewController = sut.viewController else { return XCTFail() }
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        XCTAssertNotNil(sut.loginCoordinator?.viewController)
    }

    func test_viewDidLoad_doesNotShowsLogin_ifLoggedIn() {
        sut.start()
        apiClient._isLoggedIn = true
        guard let viewController = sut.viewController else { return XCTFail() }
        
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        XCTAssertNil(sut.loginCoordinator)
    }
    
    func test_viewDidLoad_setsDeleate_ofLoginCoordinator() {
        sut.start()
        apiClient._isLoggedIn = false
        guard let viewController = sut.viewController else { return XCTFail() }

        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        guard let coordinator = sut.loginCoordinator else { return XCTFail() }
        XCTAssertTrue(coordinator.delegate is PostsCoordinator)
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
}

// MARK: - Settings
extension PostsCoordinatorTests {
    func test_showInfo_presentsSettingsViewController() {
        sut.start()
        let mockViewController = MockPostViewController(contentView: PostView(), apiClient: MockAPIClient())

        sut.showInfo(viewController: mockViewController)
        
        XCTAssertNotNil(sut.settingsCoordinator?.viewController)
    }
    
    func test_showInfo_setsDelegate_ofSettingsCoordinator() {
        sut.start()
        let mockViewController = MockPostViewController(contentView: PostView(), apiClient: MockAPIClient())
        
        sut.showInfo(viewController: mockViewController)
        
        guard let coordinator = sut.settingsCoordinator else { return XCTFail() }
        XCTAssertTrue(coordinator.delegate is PostsCoordinator)
    }
    
//    func test_settingsDidFinish_removesCoordinator() {
//        let settingsCoordinator = SettingsCoordinator(rootViewController: UINavigationController(), userDefaults: UserDefaults())
//        
//        sut.settingsDidFinish(coordinator: settingsCoordinator)
//        
//        XCTAssertEqual(sut.childCoordinators.count, 0)
//    }
}

//---------------------------------------------------------------------
// MARK: - Mocks
extension PostsCoordinatorTests {
    
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
        
        func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ()) {
        }
        
        func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ()) {
        
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
