//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class PostCoordinatorTests: XCTestCase {
    
    var sut: PostCoordinator!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()

        window = UIWindow()
        sut = PostCoordinator(window: window)
    }
    
    override func tearDown() {

        sut = nil
        window = nil
        
        super.tearDown()
    }
    
    func test_start_setsPostViewController_asRoot() {
        sut.start()
        
        XCTAssertTrue(window.rootViewController is PostViewController)
        XCTAssertEqual(sut.childViewControllers.count, 1)
    }
    
    func test_postDidFail_showsAlert() {
        let mockViewController = MockPostViewController(contentView: PostView())
        
        sut.postDidFail(viewController: mockViewController, with: NSError(domain: "Foo", code: 42, userInfo: nil))

        XCTAssertTrue(mockViewController.inTestPresentedViewController is UIAlertController)
    }
}

extension PostCoordinatorTests {
    
    class MockPostViewController: PostViewController {
        
        var inTestPresentedViewController: UIViewController?

        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            inTestPresentedViewController = viewControllerToPresent
        }
    }
}
