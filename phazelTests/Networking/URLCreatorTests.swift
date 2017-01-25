//
//  URLCreatorTests.swift
//  phazel
//
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
    guard let url = URLCreator.auth(username: "foo", password:"bar").url() else { return XCTFail() }
    
    //XCTAssertEqual(url, URL(string: "https://api.pnut.io/v0/oauth/access_token?client_id=42&password_grant_secret=23&username=foo&"))
    let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    XCTAssertEqual(urlComponents?.host, "api.pnut.io")
    XCTAssertEqual(urlComponents?.path, "/v0/oauth/access_token")
    XCTAssertTrue((urlComponents?.queryItems?.contains(URLQueryItem(name: "username", value: "foo"))) ?? false)
    XCTAssertTrue((urlComponents?.queryItems?.contains(URLQueryItem(name: "password", value: "bar"))) ?? false)
  }
}
