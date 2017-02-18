//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class MainCoordinatorTests: XCTestCase {
    
    var sut: MainCoordinator!
    var window: UIWindow!
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.makeKeyAndVisible()
        apiClient = MockAPIClient()
        sut = MainCoordinator(window: window, apiClient: apiClient)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        apiClient = nil
        
        super.tearDown()
    }
    
    func test_start_setsPostViewController_asRoot() {
        sut.start()
        
        XCTAssertTrue(window.rootViewController is PostViewController, "Found: \(window.visibleViewController)")
        XCTAssertTrue(sut.childCoordinators.first is PostCoordinator)
    }
 
    func test_start_showsLogin_ifNotLoggedIn() {
        sut.start()
        apiClient._isLoggedIn = false
        
        XCTAssertTrue(sut.childCoordinators.last is LoginCoordinator)
    }
    
    func test_start_doesNotShowsLogin_ifLoggedIn() {
        apiClient._isLoggedIn = true
        
        sut.start()
        
        XCTAssertFalse(sut.childCoordinators.last is LoginCoordinator)
    }
}

extension MainCoordinatorTests {
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
}
