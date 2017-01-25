//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class URLCreatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_authURL() {
        let username = "föö"
        let password = "@#$%^&*\\/?"
        guard let url = URLCreator.auth(username: username, password:password).url() else { return XCTFail() }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.scheme, "https")
        XCTAssertEqual(urlComponents?.host, "api.pnut.io")
        XCTAssertEqual(urlComponents?.path, "/v0/oauth/access_token")
        let queryIems = urlComponents?.queryItems
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "username", value: username))) ?? false, "Found queryItems: \(queryIems)")
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "password", value: password))) ?? false, "Found queryItems: \(queryIems)")
        XCTAssertTrue(url.absoluteString.contains("client_id="))
        XCTAssertTrue(url.absoluteString.contains("password_grant_secret="))
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "grant_type", value: "password"))) ?? false, "Found queryItems: \(queryIems)")
        XCTAssertTrue((queryIems?.contains(URLQueryItem(name: "scope", value: "stream,write_post,follow,update_profile,presence,messages"))) ?? false, "Found queryItems: \(queryIems)")
    }
}
