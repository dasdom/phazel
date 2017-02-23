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
    
    func test_login_whenSuccessful_setsToken() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "Foo", password: "Bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { error in
            XCTAssertEqual(mockKeychainManager.token, "42")
        }
    }
    
    func test_login_url() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "Foo", password: "Bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/oauth/access_token")
        }
    }
    
    func test_login_hasUsername_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        guard let encodedUsername = encode("föö") else {
                return XCTFail()
        }
        localSUT.login(username: encodedUsername, password: "foo") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            let stringData = String(data: bodyData, encoding: .utf8)
            XCTAssertTrue(stringData?.contains("username=\(encodedUsername)") ?? false)
        }
    }
    
    func test_login_hasPassword_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        guard let encodedPassword = encode("@#$%^&*\\/?") else {
            return XCTFail()
        }
        localSUT.login(username: "foo", password: encodedPassword) { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            let stringData = String(data: bodyData, encoding: .utf8)
            XCTAssertTrue(stringData?.contains("password=\(encodedPassword)") ?? false)
        }
    }
    
    func test_login_hasClientId_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            let stringData = String(data: bodyData, encoding: .utf8)
            XCTAssertTrue(stringData?.contains("client_id=") ?? false)
        }
    }
    
    func test_login_hasPasswordGrantSecret_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            let stringData = String(data: bodyData, encoding: .utf8)
            XCTAssertTrue(stringData?.contains("password_grant_secret=") ?? false)
        }
    }
    
    func test_login_hasGrantType_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            let stringData = String(data: bodyData, encoding: .utf8)
            XCTAssertTrue(stringData?.contains("grant_type=password") ?? false)
        }
    }
    
    func test_login_hasScope_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            let stringData = String(data: bodyData, encoding: .utf8)
            XCTAssertTrue(stringData?.contains("scope=stream,write_post,follow,update_profile,presence,messages") ?? false)
        }
    }
    
    func test_login_whenSuccessful_returnsUser() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"access_token\":\"42\", \"user_id\":\"23\", \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        var catchesUser: LoginUser? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .success(let user) = result {
                catchesUser = user
            }
            if case .failure(let error) = result {
                print(error)
            }
        }
        
        waitForExpectations(timeout: 0.2) { error in
            let expectedUser = LoginUser(id: "23", username: "foo")
            XCTAssertEqual(catchesUser, expectedUser)
        }
    }
    
    func test_login_setsUsername_inKeychain() {
        let mockUserDefaults = MockUserDefaults(string: "horst")
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: mockUserDefaults)
        guard let data = "{\"access_token\":\"42\", \"user_id\":\"23\", \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertEqual(mockUserDefaults.string, "foo")
        }
    }

    
    func test_HasKeychainManagerSet() {
        XCTAssertNotNil(sut.keychainManager)
    }
    
    func test_login_WhenFailed_ReturnsError() {
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
        
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertEqual(catchedError as? NSError, error)
            XCTAssertNil(mockKeychainManager.token)
        }
    }
    
    func test_login_returnsError_whenAPIReturnsErrorInMeta() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager)
        guard let data = "{\"meta\":{\"code\":404,\"error_message\":\"Not Found\"}}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        var catchedError: Error? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .failure(let requestError) = result {
                catchedError = requestError
            }
        }
        
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertEqual(catchedError as? NSError, NSError(domain: "DDHPnutAPIError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"]))
            XCTAssertNil(mockKeychainManager.token)
        }
    }
    
    func test_postsRequest_returnsPosts() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
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
        localSUT.posts(before: nil, since: nil) { result in
            if case .success(let posts) = result {
                catchedPosts = posts
            }
        }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts/streams/unified")
            XCTAssertEqual(catchedPosts?.count, 1)
        }
    }
    
    func test_postsRequest_authentication() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        let returnJson = ["{", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.posts(before: nil, since: nil) { _ in }
        
        waitForExpectations(timeout: 0.1) { error in
            guard let header = URLRequestStub.lastRequest?.allHTTPHeaderFields else { return XCTFail() }
            XCTAssertTrue(header.contains(where: { (key, value) -> Bool in
                return key == "Authorization" && value == "Bearer 42"
            }), "Found header: \(header)")
        }
    }
    
    func test_postRequest_hasPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.post(text: "Foo bar") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            let stringData = String(data: bodyData, encoding: .utf8)
            XCTAssertEqual(stringData, "text=Foo bar", "Found: \(stringData)")
        }
    }
    
    func test_postRequest_url() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.post(text: "Foo bar") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts")
        }
    }
    
    func test_postRequest_propagatesPostId() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedPostId: String? = nil
        localSUT.post(text: "Foo bar") { result in
            if case .success(let postId) = result {
                catchedPostId = postId
            }
        }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(catchedPostId, "2392")
        }
    }
    
    func test_postRequest_authentication() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(string: "horst"))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.post(text: "Foo bar") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            guard let header = URLRequestStub.lastRequest?.allHTTPHeaderFields else { return XCTFail() }
            XCTAssertTrue(header.contains(where: { (key, value) -> Bool in
                return key == "Authorization" && value == "Bearer 42"
            }), "Found header: \(header)")
        }
    }
}

extension APIClientTests {
    func encode(_ string: String) -> String? {
        let characterSet = CharacterSet(charactersIn: ":/?#[]@!$&'()*+,;=").inverted
        return string.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
}
