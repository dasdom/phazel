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
        
        var catchesUser: LoginUser? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .success(let user) = result {
                catchesUser = user
            }
        }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(mockKeychainManager.token, "42")
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/oauth/access_token")
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
        
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .failure(let requestError) = result {
                XCTAssertEqual(requestError as NSError, error)
            } else {
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(mockKeychainManager.token)
        }
    }
    
    func test_postsRequest_returnsPosts() {
        let returnJson = ["{",
                          "\"meta\": {", "\"more\": true,", "\"max_id\": \"9226\",", "\"min_id\": \"9186\",", "\"code\": 200", "},",
                          "\"data\": [",
                          "{",
                          "\"created_at\": \"2017-02-05T15:12:52Z\",",
                          "\"guid\": \"0AEB868D-31C8-4CCF-866D-A553B036B5AE\",",
                          "\"id\": \"9226\",",
                          "\"source\": {", "\"name\": \"Goober\"", "},",
                          "\"user\": {", "},",
                          "\"content\": {", "\"text\": \"@Nasendackel Danke! I'm glad folks are enjoying it!\\n/@teebeuteltier\"", "},", "\"you_bookmarked\": false,", "\"you_reposted\": false,", "\"pagination_id\": \"9226\"", "}]}"].joined(separator: "\n")
        
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
