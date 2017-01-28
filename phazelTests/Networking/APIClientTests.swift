//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    
    override func setUp() {
        super.setUp()
        
        sut = APIClient()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_LoginRequest_WhenSuccessful_CallsKeychainManager() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "Foo", password: "Bar") { success, _ in
            XCTAssertTrue(success)
        }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(mockKeychainManager.token, "42")
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/oauth/access_token")
        }
    }
    
    func test_HasKeychainManagerSet() {
        XCTAssertNotNil(sut.keychainManager)
    }
    
    func test_LoginRequest_WhenFailed_ReturnsError() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        let error = NSError(domain: "FooDomain", code: 42, userInfo: nil)
        URLRequestStub.stub(error: error, expect: expectation(description: "Failed request"))
        
        localSUT.login(username: "Foo", password: "Bar") { _, requestError in
            XCTAssertEqual(requestError as? NSError, error)
        }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(mockKeychainManager.token)
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
        
        func deleteToken(for username: String) {
            
        }
    }
}
