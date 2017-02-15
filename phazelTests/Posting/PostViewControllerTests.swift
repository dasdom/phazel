//
//  PostViewControllerTests.swift
//  phazel
//
//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class PostViewControllerTests: XCTestCase {
    
    var sut: PostViewController!
    
    override func setUp() {
        super.setUp()

        let mockView = MockView()
        sut = PostViewController(contentView: mockView)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_setsView() {
        XCTAssertTrue(sut.view is MockView)
    }
    
}

extension PostViewControllerTests {
    class MockView: UIView, PostViewProtocol {
        var text: String? {
            return "Foo"
        }
    }
}
