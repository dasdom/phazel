//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class APIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_LoginRequests_WhenSuccessful_CallsKeychainManager() {
        let mockKeychainManager = MockKeychainManager()
        let sut = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        let requestExpectation = expectation(description: "Login request")
        URLRequestStub.stub(with: data, expect: requestExpectation)
        
        var catchedSuccess = false
        sut.login(username: "Foo", password: "Bar") { success in
            catchedSuccess = success
        }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertTrue(catchedSuccess)
            XCTAssertEqual(mockKeychainManager.token, "42")
            let urlComponents = URLRequestStub.lastURLComponents()
            XCTAssertEqual(urlComponents?.host, "api.pnut.io")
            XCTAssertEqual(urlComponents?.path, "/v0/oauth/access_token")
        }
    }
}

extension APIClientTests {
    class MockKeychainManager: KeychainManagerProtocol {
        
        var token: String?
        
        func set(token: String, for username: String) {
            self.token = token
        }
        
        func token(for username: String) -> String? {
            return token
        }
    }
}
