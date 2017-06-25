//  Created by dasdom on 21.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class GlobalCoordinatorTests: XCTestCase {
    
    var sut: GlobalCoordinator!
    var apiClient: MockAPIClient!
    let userDefaults = UserDefaults()
    
    override func setUp() {
        super.setUp()
        
        apiClient = MockAPIClient(result: Result(value: [["foo": 23]], error: nil))
        sut = GlobalCoordinator(rootViewController: UINavigationController(), apiClient: apiClient, userDefaults: userDefaults)
    }
    
    override func tearDown() {
        sut = nil
        apiClient = nil
        
        super.tearDown()
    }
}

// MARK: - General
extension GlobalCoordinatorTests {
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
        let postsViewControllerMock = GlobalViewControllerMock(apiClient: MockAPIClient())
        sut.viewController = postsViewControllerMock
        target.perform(action)
        
        guard let presentedViewController = postsViewControllerMock.inTestPresentedViewController as? UINavigationController else {
            return XCTFail()
        }
        guard let postingViewController = presentedViewController.viewControllers.first as? PostingViewController else { return XCTFail() }
        XCTAssertTrue(postingViewController.delegate is PostsCoordinator)
    }
}

extension GlobalCoordinatorTests {
    class GlobalViewControllerMock: GlobalViewController {
        
        var inTestPresentedViewController: UIViewController?
        var dismissCallCount = 0
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            inTestPresentedViewController = viewControllerToPresent
        }
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissCallCount += 1
        }
    }
}
