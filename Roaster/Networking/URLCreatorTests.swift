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
        True((queryIems?.contains(URLQueryItem(name: "before_id", value: "42"))), "Found queryItems: \(String(describing: queryIems))")
    }
    
    func test_postsURL_sinceId() throws {
        let url = try unwrap(URLCreator.posts(before: nil, since: 23).url())
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        True((queryIems?.contains(URLQueryItem(name: "since_id", value: "23"))), "Found queryItems: \(String(describing: queryIems))")
    }
    
    func test_postsURL_count() throws {
        let url = try unwrap(URLCreator.posts(before: nil, since: 23).url())
        
        let queryIems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        True((queryIems?.contains(URLQueryItem(name: "count", value: "200"))), "Found queryItems: \(String(describing: queryIems))")
    }
    
    func test_threadURL_count() throws {
        
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

// MARK: - Profile posts
extension URLCreatorTests {
    func test_profilePostsURL_scheme() throws {
        let url = try unwrap(URLCreator.profilePosts(userId: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_profilePostsURL_host() throws {
        let url = try unwrap(URLCreator.profilePosts(userId: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_profilePostsURL_path() throws {
        let url = try unwrap(URLCreator.profilePosts(userId: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/users/42/posts")
    }
}

// MARK: - Global posts
extension URLCreatorTests {
    func test_globalPostsURL_scheme() throws {
        let url = try unwrap(URLCreator.globalPosts(before: nil, since: nil).url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_globalPostsURL_host() throws {
        let url = try unwrap(URLCreator.globalPosts(before: nil, since: nil).url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_globalPostsURL_path() throws {
        let url = try unwrap(URLCreator.globalPosts(before: nil, since: nil).url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/posts/streams/global")
    }
}

// MARK: - Mentions
extension URLCreatorTests {
    func test_mentionsURL_scheme() throws {
        let url = try unwrap(URLCreator.mentions(userId: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_mentionsPostsURL_host() throws {
        let url = try unwrap(URLCreator.mentions(userId: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_mentionsURL_path() throws {
        let url = try unwrap(URLCreator.mentions(userId: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/users/42/mentions")
    }
}

// MARK: - Follow/unfollow
extension URLCreatorTests {
    func test_followURL_scheme() throws {
        let url = try unwrap(URLCreator.follow(id: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_followURL_host() throws {
        let url = try unwrap(URLCreator.follow(id: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_followURL_path42() throws {
        let url = try unwrap(URLCreator.follow(id: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/users/42/follow")
    }
    
    func test_followURL_path23() throws {
        let url = try unwrap(URLCreator.follow(id: "23").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/users/23/follow")
    }
}

// MARK: - User
extension URLCreatorTests {
    func test_userURL_scheme() throws {
        let url = try unwrap(URLCreator.user(id: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
    }
    
    func test_userURL_host() throws {
        let url = try unwrap(URLCreator.user(id: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    }
    
    func test_userURL_path42() throws {
        let url = try unwrap(URLCreator.user(id: "42").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/users/42")
    }
    
    func test_userURL_path23() throws {
        let url = try unwrap(URLCreator.user(id: "23").url())
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.path, "/v0/users/23")
    }
}
