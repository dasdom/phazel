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
        
        let expectedUser = LoginUser(id: 23, username: "foo")
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .success(let user) = result {
                XCTAssertEqual(user, expectedUser)
            }
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
        
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .failure(let requestError) = result {
                XCTAssertEqual(requestError as NSError, error)
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
                          "\"user\": {", "\"username\": \"33MHz\",", "\"name\": \"Robert\",", "\"content\": {", "\"avatar_image\": {", "\"width\": 1200,", "\"height\": 1200,", "\"link\": \"https://d26y28lt6cxszo.cloudfront.net/avatar/4hxiGBxrSHhBzcABGX45sJxcFsHEJ_1Kq2o04iZ2-siG--l1CONPCNRvzhwW1HWXQ3DqNxyvzj4LlY1x9EJ_Or1xGGqM9iAQxFnV1lIOx6hVnq6Tm6oX714IGgovER3dYC98oLsoj7ND\",", "\"is_default\": false", "},", "\"follows_you\": true,", "\"you_blocked\": false,", "\"you_follow\": true,", "},",
                          "\"content\": {", "\"html\": \"<span itemscope=\"https://pnut.io/schemas/Post\"><span data-mention-id=\"194\" data-mention-name=\"Nasendackel\" itemprop=\"mention\">@Nasendackel</span> Danke! I'm glad folks are enjoying it!<br>/<span data-mention-id=\"119\" data-mention-name=\"teebeuteltier\" itemprop=\"mention\">@teebeuteltier</span></span>\",", "\"text\": \"@Nasendackel Danke! I'm glad folks are enjoying it!\n/@teebeuteltier\",", "},", "\"you_bookmarked\": false,", "\"you_reposted\": false,", "\"pagination_id\": \"9226\"", "}"].joined(separator: "\n")
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
