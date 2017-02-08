//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class URLCreatorTests: XCTestCase {

}

// MARK: - Auth
extension URLCreatorTests {
    func test_authURL_scheme() {
        let username = "foo"
        let password = "bar"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_authURL_host() {
        let username = "foo"
        let password = "bar"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_authURL_path() {
        let username = "foo"
        let password = "bar"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/oauth/access_token")
    }

    func test_authURL_usernameAndPassword() {
        let username = "föö"
        let password = "@#$%^&*\\/?"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "username", value: username))) ?? false, "Found queryItems: \(queryIems)")
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "password", value: password))) ?? false, "Found queryItems: \(queryIems)")
    }

    func test_authURL_clientId() {
        let username = "foo"
        let password = "bar"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        XCTAssertTrue(url.absoluteString.contains("client_id="))
    }
    
    func test_authURL_passwordGrantSecret() {
        let username = "foo"
        let password = "bar"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        XCTAssertTrue(url.absoluteString.contains("password_grant_secret="))
    }
    
    func test_authURL_grantType() {
        let username = "foo"
        let password = "bar"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "grant_type", value: "password"))) ?? false, "Found queryItems: \(queryIems)")
    }
    
    func test_authURL_scope() {
        let username = "foo"
        let password = "bar"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "scope", value: "stream,write_post,follow,update_profile,presence,messages"))) ?? false, "Found queryItems: \(queryIems)")
    }
 
}

// MARK: - Posts
extension URLCreatorTests {
    func test_postsURL_scheme() {
        guard let url = URLCreator.posts(before: 42, since: nil).url() else { return XCTFail() }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_postsURL_host() {
        guard let url = URLCreator.posts(before: 42, since: nil).url() else { return XCTFail() }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }

    func test_postsURL_path() {
        guard let url = URLCreator.posts(before: 42, since: nil).url() else { return XCTFail() }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/posts/streams/unified")
    }
    
    func test_postsURL_beforeId() {
        guard let url = URLCreator.posts(before: 42, since: nil).url() else { return XCTFail() }
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "before_id", value: "42"))) ?? false, "Found queryItems: \(queryIems)")
    }
    
    func test_postsURL_sinceId() {
        guard let url = URLCreator.posts(before: nil, since: 23).url() else { return XCTFail() }
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "since_id", value: "23"))) ?? false, "Found queryItems: \(queryIems)")
    }
    
    func test_postsURL_count() {
        guard let url = URLCreator.posts(before: nil, since: 23).url() else { return XCTFail() }
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "count", value: "200"))) ?? false, "Found queryItems: \(queryIems)")
    }
}
