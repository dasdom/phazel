//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel
import SafariServices

class PostsCoordinatorTests: XCTestCase {
    
    var sut: PostsCoordinator!
    var window: UIWindow!
    var apiClient: MockAPIClient!
    let userDefaults = UserDefaults()

    override func setUp() {
        super.setUp()
        
        apiClient = MockAPIClient(result: Result(value: [["foo": 23]], error: nil))
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

        sut.reply(postsViewControllerMock, to: post)
        
        guard let presentedViewController = postsViewControllerMock.inTestPresentedViewController as? UINavigationController else {
            return XCTFail()
        }
        guard let postingViewController = presentedViewController.viewControllers.first as? PostingViewController else { return XCTFail() }
        XCTAssertTrue(postingViewController.delegate is PostsCoordinator)
        XCTAssertEqual(postingViewController.postToReplyTo, post)
    }
    
    func test_postingViewController_cancelButtonAction_dismisses() {
        sut.start()
        let postsViewControllerMock = PostsViewControllerMock(apiClient: MockAPIClient())
        sut.viewController = postsViewControllerMock
        let post = Post(dict: ["id": "23"])
        
        sut.reply(postsViewControllerMock, to: post)
       
        guard let presentedViewController = postsViewControllerMock.inTestPresentedViewController as? UINavigationController else {
            return XCTFail()
        }
        guard let postingViewController = presentedViewController.viewControllers.first as? PostingViewController else { return XCTFail() }
        guard let target = postingViewController.navigationItem.leftBarButtonItem?.target as? PostsCoordinator else { return XCTFail() }
        guard let action = postingViewController.navigationItem.leftBarButtonItem?.action else { return XCTFail() }
        
        target.perform(action)

        XCTAssertNil(sut.rootViewController.presentedViewController)
    }
    
    func test_showProfile_showsProfile() {
        let navigationControllerMock = NavigationControllerMock(rootViewController: UIViewController())
        let localSUT = PostsCoordinator(rootViewController: navigationControllerMock, apiClient: MockAPIClient(), userDefaults: userDefaults)
        localSUT.start()
        
        localSUT.showProfile(localSUT.viewController!, for: Post(dict: ["user": ["id": "23"]]))
        
        XCTAssertTrue(navigationControllerMock.lastPushedViewController is ProfileViewController)
    }
    
    func test_showThread_showsThread() {
        let navigationControllerMock = NavigationControllerMock(rootViewController: UIViewController())
        let localSUT = PostsCoordinator(rootViewController: navigationControllerMock, apiClient: MockAPIClient(), userDefaults: userDefaults)
        localSUT.start()
        
        localSUT.showThread(localSUT.viewController!, for: Post(dict: ["thread_id": "23"]))
        
        XCTAssertTrue(navigationControllerMock.lastPushedViewController is ThreadViewController)
    }
    
    func test_tappedLink_showsSafariViewController() {
        sut.start()
        let postsViewControllerMock = PostsViewControllerMock(apiClient: MockAPIClient())
        sut.viewController = postsViewControllerMock
    
        sut.viewController(postsViewControllerMock, tappedLink: Link(dict: ["link": "http://foo.com"]))

        XCTAssertTrue(postsViewControllerMock.inTestPresentedViewController is SFSafariViewController)
    }
    
    func test_tappedUser_showsProfile() {
        let navigationControllerMock = NavigationControllerMock(rootViewController: UIViewController())
        let localSUT = PostsCoordinator(rootViewController: navigationControllerMock, apiClient: MockAPIClient(), userDefaults: userDefaults)
        localSUT.start()
        
        localSUT.viewController(localSUT.viewController!, tappedUser: User(dict: ["id": "23"]))
        
        XCTAssertTrue(navigationControllerMock.lastPushedViewController is ProfileViewController)
    }
}

// MARK: - Posting
extension PostsCoordinatorTests {
    func test_send_callsAPIClientMethod() {
        apiClient.postResult = Result(value: "foo", error: nil)
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
        var dismissCallCount = 0
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            inTestPresentedViewController = viewControllerToPresent
        }
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissCallCount += 1
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
        
        override func configure(with post: Post, forPresentation: Bool = true) {
            self.post = post
        }
    }
    
    class NavigationControllerMock: UINavigationController {
        
        var lastPushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            lastPushedViewController = viewController
        }
    }
}
