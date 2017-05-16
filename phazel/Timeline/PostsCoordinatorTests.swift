//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class PostsCoordinatorTests: XCTestCase {
    
    var sut: PostsCoordinator!
    var window: UIWindow!
    var apiClient: MockAPIClient!
    let userDefaults = UserDefaults()

    override func setUp() {
        super.setUp()
        
        apiClient = MockAPIClient()
        sut = PostsCoordinator(rootViewController: UINavigationController(), apiClient: apiClient, userDefaults: userDefaults)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        apiClient = nil
        
        super.tearDown()
    }
}

// MARK: - General
extension PostsCoordinatorTests {
    func test_start_setsDelegate() {
        sut.start()
        guard let viewController = sut.viewController else { return XCTFail() }
        
        XCTAssertTrue(viewController.delegate is PostsCoordinator)
    }
    
    func test_start_setsDataSourceOfCollectionView() {
        sut.start()
        
        guard let viewController = sut.viewController else { return XCTFail() }
        guard let dataSource = viewController.tableView?.dataSource else { return XCTFail() }
        XCTAssertTrue(dataSource is TableViewDataSource<PostsCoordinator>)
    }
    
    func test_start_setsDataSourceOfViewController() {
        sut.start()
        
        guard let viewController = sut.viewController else { return XCTFail() }
        XCTAssertNotNil(viewController.dataSource)
    }
    
    func test_start_setsNavigationItems_ofViewController() {
        sut.start()
        
        guard let viewController = sut.viewController else { return XCTFail() }
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_start_setsComposeNavigationItem_withTargetAndAction() {
        sut.start()
        
        guard let viewController = sut.viewController else { return XCTFail() }
        guard let target = viewController.navigationItem.rightBarButtonItem?.target as? PostsCoordinator else { return XCTFail() }
        guard let action = viewController.navigationItem.rightBarButtonItem?.action else { return XCTFail() }
        // Inject mock view to record the presentation of the view controller
        let postsViewControllerMock = PostsViewControllerMock(apiClient: MockAPIClient())
        sut.viewController = postsViewControllerMock
        target.perform(action)
        
        guard let presentedViewController = postsViewControllerMock.inTestPresentedViewController as? UINavigationController else {
            return XCTFail()
        }
        guard let postingViewController = presentedViewController.viewControllers.first as? PostingViewController else { return XCTFail() }
        XCTAssertTrue(postingViewController.delegate is PostsCoordinator)
    }
    
    func test_configure_callsConfigure_onCell() {
        let cell = PostCellMock()
        let dict = ["id": "23"]
        let post = Post(dict: dict)
        
        sut.configure(cell, for: post)
        
        XCTAssertEqual(cell.post, post)
    }
    
    func test_reply_presentsPostingViewController() {
        sut.start()
        let postsViewControllerMock = PostsViewControllerMock(apiClient: MockAPIClient())
        sut.viewController = postsViewControllerMock
        let dict = ["id": "23"]
        let post = Post(dict: dict)

        sut.reply(to: post)
        
        guard let presentedViewController = postsViewControllerMock.inTestPresentedViewController as? UINavigationController else {
            return XCTFail()
        }
        guard let postingViewController = presentedViewController.viewControllers.first as? PostingViewController else { return XCTFail() }
        XCTAssertTrue(postingViewController.delegate is PostsCoordinator)
        XCTAssertEqual(postingViewController.postToReplyTo, post)
    }
}

// MARK: - Posting
extension PostsCoordinatorTests {
    func test_send_callsAPIClientMethod() {
        sut.send(text: "foo", replyTo: nil)
        
        XCTAssertEqual(apiClient.postedText, "foo")
    }
    
    func test_sendFailure_presentsAlert() {
        let result = Result<String>(value: nil, error: NSError(domain: "TestError", code: 1234, userInfo: nil))
        let mockAPIClient = MockAPIClient(result: result)
        let postsViewControllerMock = PostsViewControllerMock(apiClient: mockAPIClient)
        sut = PostsCoordinator(rootViewController: UINavigationController(), apiClient: mockAPIClient, userDefaults: userDefaults)
        sut.viewController = postsViewControllerMock
        
        sut.send(text: "Foo", replyTo: nil)
        
        XCTAssertTrue(postsViewControllerMock.inTestPresentedViewController is UIAlertController)
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

        sut.showInfo()
        
        XCTAssertNotNil(sut.settingsCoordinator?.viewController)
    }
    
    func test_showInfo_setsDelegate_ofSettingsCoordinator() {
        sut.start()
        
        sut.showInfo()
        
        guard let coordinator = sut.settingsCoordinator else { return XCTFail() }
        XCTAssertTrue(coordinator.delegate is PostsCoordinator)
    }
}

//---------------------------------------------------------------------
// MARK: - Mocks
extension PostsCoordinatorTests {
    
    class PostsViewControllerMock: PostsViewController {
        
        var inTestPresentedViewController: UIViewController?

        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            inTestPresentedViewController = viewControllerToPresent
        }
    }
    
    class MockAPIClient: APIClientProtocol {
        
        var _isLoggedIn = false
        var postedText: String?
        var stringResult: Result<String>?
        
        init(result: Result<String>? = nil) {
            stringResult = result
        }
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        }
        
        func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ()) {
            postedText = text
            if let result = stringResult {
                completion(result)
            }
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
    
    class PostCellMock: PostCell {
        
        var post: Post?
        
        override func configure(with post: Post, loadImage: Bool = true) {
            self.post = post
        }
    }
}
