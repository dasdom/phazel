//  Created by dasdom on 30/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    
    override func setUp() {
        super.setUp()

        let mockView = MockView()
        sut = LoginViewController(contentView: mockView)
        
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_setsView() {
        XCTAssertTrue(sut.view is MockView)
    }
    
    func test_isLoginProtocol() {
        XCTAssertTrue(sut is LoginProtocol)
    }
    
    func test_login_callsAPIClientMethod() {
        let mockView = MockView()
        let mockAPIClient = MockAPIClient()
        let localSUT = LoginViewController(contentView: mockView, apiClient: mockAPIClient)
        
        localSUT.login()
        
        XCTAssertEqual(mockAPIClient.username, "Foo")
        XCTAssertEqual(mockAPIClient.password, "Bar")
    }
}

extension LoginViewControllerTests {
    class MockView: UIView, LoginViewProtocol {
        var username: String? {
            return "Foo"
        }
        
        var password: String? {
            return "Bar"
        }
    }
    
    class MockAPIClient: APIClientProtocol {
        
        var username: String?
        var password: String?
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
            self.username = username
            self.password = password
        }
    }
}
