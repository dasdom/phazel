//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import Roaster

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
    
    func test_loginRequest_whenSuccessful_setsToken() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "Foo", password: "Bar") { _ in }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(mockKeychainManager.token, "42")
        }
    }
    
    func test_loginRequest_url() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "Foo", password: "Bar") { _ in }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/oauth/access_token")
        }
    }
    
    func test_loginRequest_whenSuccessful_returnsUser() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        var catchesUser: LoginUser? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .success(let user) = result {
                catchesUser = user
            }
        }
        
        waitForExpectations(timeout: 0.1) { error in
            let expectedUser = LoginUser(id: 23, username: "foo")
            XCTAssertEqual(catchesUser, expectedUser)
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
        
        var catchedError: Error? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .failure(let requestError) = result {
                catchedError = requestError
            }
        }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(catchedError as? NSError, error)
            XCTAssertNil(mockKeychainManager.token)
        }
    }
    
    func test_postsRequest_returnsPosts() {
        let returnJson = ["{",
                          "\"data\": [",
                          "{",
                          "\"content\": {", "\"text\": \"@Nasendackel Danke! I'm glad folks are enjoying it!\\n/@teebeuteltier\"", "}",
                          "}",
                          "]",
                          "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedPosts: [Post]? = nil
        sut.posts(before: nil, since: nil) { result in
            if case .success(let posts) = result {
                catchedPosts = posts
            }
        }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts/streams/unified")
            XCTAssertEqual(catchedPosts?.count, 1)
        }
    }
}
