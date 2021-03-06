//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import Roaster
import phazel

class APIClientTests: DDHTestCase {
    
    var sut: APIClient!
    let userDefaults = UserDefaults()
    
    override func setUp() {
        super.setUp()
        
        sut = APIClient(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

// MARK: - Login
extension APIClientTests {
    func test_login_whenSuccessful_setsToken() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager, userDefaults: userDefaults)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "Foo", password: "Bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { error in
            XCTAssertEqual(mockKeychainManager.token, "42")
        }
    }
    
    func test_login_url() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager, userDefaults: userDefaults)
        guard let data = "{\"access_token\":\"42\", \"user_id\":23, \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "Foo", password: "Bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/oauth/access_token")
        }
    }
    
    func test_login_hasUsername_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        guard let encodedUsername = encode("föö") else {
                return XCTFail()
        }
        localSUT.login(username: " föö ", password: "foo") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            self.body(of: URLRequestStub.lastRequest, contains: "username=\(encodedUsername)")
        }
    }
    
    func test_login_hasPassword_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        guard let encodedPassword = encode("@#$%^&*\\/?") else {
            return XCTFail()
        }
        localSUT.login(username: "foo", password: encodedPassword) { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            self.body(of: URLRequestStub.lastRequest, contains: "password=\(encodedPassword)")
        }
    }
    
    func test_login_hasClientId_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 1.0) { _ in
            self.body(of: URLRequestStub.lastRequest, contains: "client_id=")
        }
    }
    
    func test_login_hasPasswordGrantSecret_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            self.body(of: URLRequestStub.lastRequest, contains: "password_grant_secret=")
        }
    }
    
    func test_login_hasGrantType_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            self.body(of: URLRequestStub.lastRequest, contains: "grant_type=password")
        }
    }
    
    func test_login_hasScope_inPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 0.2) { _ in
            self.body(of: URLRequestStub.lastRequest, contains: "scope=stream,write_post,follow,update_profile,presence,messages")
        }
    }
    
    func test_login_whenSuccessful_returnsUser() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager, userDefaults: userDefaults)
        guard let data = "{\"access_token\":\"42\", \"user_id\":\"23\", \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        var catchesUser: LoginUser? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .success(let user) = result {
                catchesUser = user
            }
            if case .failure(let error) = result {
                // print(error)
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            let expectedUser = LoginUser(id: "23", username: "foo")
            XCTAssertEqual(catchesUser, expectedUser)
        }
    }
    
    func test_login_setsUsername_inUserDefaults() {
        let mockUserDefaults = MockUserDefaults(values:["username":"horst"])
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: mockUserDefaults)
        guard let data = "{\"access_token\":\"42\", \"user_id\":\"23\", \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(mockUserDefaults.string(forKey: "username"), "foo")
        }
    }

    func test_login_setsAccounts_inUserDefaults() {
        let mockUserDefaults = MockUserDefaults()
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: mockUserDefaults)
        guard let data = "{\"access_token\":\"42\", \"user_id\":\"23\", \"username\":\"foo\"}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        localSUT.login(username: "foo", password: "bar") { _ in }
        
        waitForExpectations(timeout: 1) { _ in
            guard let accounts = mockUserDefaults.value(forKey: "accounts") as? [Any],
                let account = accounts.first as? [String:String] else { return XCTFail() }
            XCTAssertEqual(account, ["username": "foo", "id": "23"])
        }
    }
    
    func test_HasKeychainManagerSet() {
        XCTAssertNotNil(sut.keychainManager)
    }
    
    func test_login_WhenFailed_ReturnsError() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager, userDefaults: userDefaults)
        let error = NSError(domain: "FooDomain", code: 42, userInfo: nil)
        URLRequestStub.stub(error: error, expect: expectation(description: "Failed request"))
        
        var catchedError: Error? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            if case .failure(let requestError) = result {
                catchedError = requestError
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(catchedError as NSError?, error)
            XCTAssertNil(mockKeychainManager.token)
        }
    }
    
    func test_login_returnsError_whenAPIReturnsErrorInMeta() {
        let mockKeychainManager = MockKeychainManager()
        let localSUT = APIClient(keychainManager: mockKeychainManager, userDefaults: userDefaults)
        guard let data = "{\"meta\":{\"code\":404,\"error_message\":\"Not Found\"}}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: data, expect: expectation(description: "Login request"))
        
        var catchedError: Error? = nil
        var catchesResult: Result<LoginUser>? = nil
        localSUT.login(username: "Foo", password: "Bar") { result in
            catchesResult = result
            if case .failure(let requestError) = result {
                catchedError = requestError
            } else {
                // print(result)
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            guard let unwrappedError = catchedError else {
                // print("catchedResult: \(String(describing: catchesResult))")
                // print("catchedError: \(String(describing: catchedError))")
                fatalError()
//                return XCTFail()
            }
            XCTAssertEqual(unwrappedError as NSError, NSError(domain: "DDHPnutAPIError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"]))
            XCTAssertNil(mockKeychainManager.token)
        }
    }
}

// MARK: - Posts
extension APIClientTests {
    func test_posts_hasCorrectPath() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.posts(before: nil, since: nil) {_ in }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts/streams/unified")
        }
    }
    
    func test_posts_returnsDict() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"data\": [", "{",
                          "}", "]", "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedDict: [[String: Any]]?
        localSUT.posts(before: nil, since: nil) { result in
            if case .success(let dict) = result {
                catchedDict = dict
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedDict?.count, 1)
        }
    }
    
    func test_posts_authentication() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.posts(before: nil, since: nil) { _ in }
        
        waitForExpectations(timeout: 0.1) { error in
            self.header(of: URLRequestStub.lastRequest, containsValue: "Bearer 42", forKey: "Authorization")
        }
    }
}

// MARK: - Thread
extension APIClientTests {
    func test_thread_hasCorrectPath() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        
        guard let returnData = "{}".data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.threadFor(postId: 23) { _ in }
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts/23/thread")
        }
    }
    
    func test_thread_returnsDict() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"data\": [", "{",
                          "}", "]", "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Thread request"))
        
        var catchedDict: [[String: Any]]?
        localSUT.threadFor(postId: 23) { result in
            if case .success(let dict) = result {
                catchedDict = dict
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedDict?.count, 1)
        }
    }
}

// MARK: - Posting
extension APIClientTests {
    func test_post_hasPostData() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.post(text: "Foo bar") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            guard let bodyData = URLRequestStub.lastRequest?.httpBody else { return XCTFail() }
            guard let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
                  let bodyDict = json as? [String:String] else {
                    return XCTFail()
            }
            XCTAssertEqual(bodyDict, ["text":"Foo bar"], "Found: \(bodyDict)")
        }
    }
    
    func test_post_url() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.post(text: "Foo bar") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts")
        }
    }
    
    func test_post_propagatesPostId() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedPostId: String? = nil
        localSUT.post(text: "Foo bar") { result in
            if case .success(let postId) = result {
                catchedPostId = postId
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(catchedPostId, "2392")
        }
    }
    
    func test_post_authentication() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
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

// MARK: - Profile
extension APIClientTests {
    func test_profilePost_path() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.profilePosts(userId: "23") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/users/23/posts")
        }
    }
    
    func test_profilePosts_returnsDict() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"data\": [", "{",
                          "}", "]", "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedArray: [[String: Any]]?
        localSUT.profilePosts(userId: "42") { result in
            if case .success(let dict) = result {
                catchedArray = dict
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedArray?.count, 1)
        }
    }
}

// MARK: - Mentions
extension APIClientTests {
    func test_mentions_path() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.mentions(userId: "23") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/users/23/mentions")
        }
    }
    
    func test_mentions_returnsDict() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"data\": [", "{",
                          "}", "]", "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedArray: [[String: Any]]?
        localSUT.mentions(userId: "42") { result in
            if case .success(let dict) = result {
                catchedArray = dict
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedArray?.count, 1)
        }
    }
}


// MARK: - User
extension APIClientTests {
    func test_user_path() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 200", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.user(id: "23") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/users/23")
        }
    }
    
    func test_user_returnsDict() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"data\": {", "\"id\": \"2392\"", "}", "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedDict: [String: Any]?
        localSUT.user(id: "42") { result in
            if case .success(let dict) = result {
                catchedDict = dict
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedDict?.count, 1)
        }
    }
}

// MARK: - Follow/unfollow
extension APIClientTests {
    func test_follow_path() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 200", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.follow(true, userId: "23") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/users/23/follow")
        }
    }
    
    func test_follow_method() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 200", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.follow(true, userId: "23") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastRequest?.httpMethod, "PUT")
        }
    }
    
    func test_follow_returnsDict() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"data\": {", "\"id\": \"2392\"", "}", "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedDict: [String: Any]?
        localSUT.follow(true, userId: "42") { result in
            if case .success(let dict) = result {
                catchedDict = dict
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedDict?.count, 1)
        }
    }
    
    func test_unfollow_path() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 200", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.follow(false, userId: "23") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/users/23/follow")
        }
    }
    
    func test_unfollow_method() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 200", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.follow(false, userId: "23") { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastRequest?.httpMethod, "DELETE")
        }
    }
    
    func test_unfollow_returnsDict() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"data\": {", "\"id\": \"2392\"", "}", "}"].joined(separator: "\n")
        
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        var catchedDict: [String: Any]?
        localSUT.follow(false, userId: "42") { result in
            if case .success(let dict) = result {
                catchedDict = dict
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedDict?.count, 1)
        }
    }
}

// MARK: - Global
extension APIClientTests {
    func test_globalPosts_path() {
        let localSUT = APIClient(keychainManager: MockKeychainManager(token: "42"), userDefaults: MockUserDefaults(values:["username":"horst"]))
        let returnJson = ["{", "\"meta\": {", "\"code\": 201", "},", "\"data\": {", "\"id\": \"2392\",", "}", "}"].joined(separator: "\n")
        guard let returnData = returnJson.data(using: .utf8) else { return XCTFail() }
        URLRequestStub.stub(data: returnData, expect: expectation(description: "Post request"))
        
        localSUT.globalPosts(before: nil, since: nil) { _ in }
        
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts/streams/global")
        }
    }
}

extension APIClientTests {
    func encode(_ string: String) -> String? {
        let characterSet = CharacterSet(charactersIn: ":/?#[]@!$&'()*+,;= ").inverted
        return string.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
}
