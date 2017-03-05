//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import Roaster

class URLCreatorTests: DDHTestCase {

}

// MARK: - Auth
extension URLCreatorTests {
    func test_authURL_scheme() throws {
        let url = try unwrap(URLCreator.auth.url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_authURL_host() throws {
        let url = try unwrap(URLCreator.auth.url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_authURL_path() throws {
        let url = try unwrap(URLCreator.auth.url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/oauth/access_token")
    }
}

// MARK: - Posts
extension URLCreatorTests {
    func test_postsURL_scheme() throws {
        let url = try unwrap(URLCreator.posts(before: 42, since: nil).url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_postsURL_host() throws {
        let url = try unwrap(URLCreator.posts(before: 42, since: nil).url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }

    func test_postsURL_path() throws {
        let url = try unwrap(URLCreator.posts(before: 42, since: nil).url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/posts/streams/unified")
    }
    
    func test_postsURL_beforeId() throws {
        let url = try unwrap(URLCreator.posts(before: 42, since: nil).url())
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        True((queryIems?.contains(URLQueryItem(name: "before_id", value: "42"))), "Found queryItems: \(queryIems)")
    }
    
    func test_postsURL_sinceId() throws {
        let url = try unwrap(URLCreator.posts(before: nil, since: 23).url())
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        True((queryIems?.contains(URLQueryItem(name: "since_id", value: "23"))), "Found queryItems: \(queryIems)")
    }
    
    func test_postsURL_count() throws {
        let url = try unwrap(URLCreator.posts(before: nil, since: 23).url())
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        True((queryIems?.contains(URLQueryItem(name: "count", value: "200"))), "Found queryItems: \(queryIems)")
    }
}

// MARK: - Posting
extension URLCreatorTests {
    func test_postURL_scheme() throws {
        let url = try unwrap(URLCreator.post.url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_postURL_host() throws {
        let url = try unwrap(URLCreator.post.url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_postURL_path() throws {
        let url = try unwrap(URLCreator.post.url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/posts")
    }
}
