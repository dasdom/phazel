//  Created by Dominik Hauser on 01/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class LoginCoordinatorTests: XCTestCase {
    
    var sut: LoginCoordinator!
    let mockNavigationController = MockNavigationController()
    
    override func setUp() {
        super.setUp()

        sut = LoginCoordinator(navigationController: mockNavigationController)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_isLoginViewControllerDelegate() {
        XCTAssertTrue(sut is LoginViewControllerDelegate)
    }
    
}

extension LoginCoordinatorTests {
    class MockNavigationController: UINavigationController {
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            
        }
    }
}
