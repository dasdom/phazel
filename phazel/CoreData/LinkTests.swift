//  Created by dasdom on 02/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class LinkTests: XCTestCase {
    
    func test_LinkInit_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let link = Link(dict: dict)
        
        XCTAssertEqual(link.pos, 180)
        XCTAssertEqual(link.len, 23)
    }
    
    func test_LinkInit_setsLink() {
        let dict: [String:Any] = ["link": "http://foo.com"]
        let link = Link(dict: dict)
        
        XCTAssertEqual(link.link, "http://foo.com")
    }
    
    func test_LinkInit_setsText() {
        let dict: [String:Any] = ["text": "foo"]
        let link = Link(dict: dict)
        
        XCTAssertEqual(link.text, "foo")
    }
}

//**************************************************
//**************************************************
extension LinkTests {
    func test_unarchive_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let link = Link(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: link)
        guard let unarchivedLink = NSKeyedUnarchiver.unarchiveObject(with: data) as? Link else { return XCTFail() }
        
        XCTAssertEqual(unarchivedLink.pos, 180)
        XCTAssertEqual(unarchivedLink.len, 23)
    }
    
    func test_unarchive_setsLink() {
        let dict: [String:Any] = ["link": "http://foo.com"]
        let link = Link(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: link)
        guard let unarchivedLink = NSKeyedUnarchiver.unarchiveObject(with: data) as? Link else { return XCTFail() }
        
        XCTAssertEqual(unarchivedLink.link, "http://foo.com")
    }
    
    func test_unarchive_setsText() {
        let dict: [String:Any] = ["text": "foo"]
        let link = Link(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: link)
        guard let unarchivedLink = NSKeyedUnarchiver.unarchiveObject(with: data) as? Link else { return XCTFail() }
        
        XCTAssertEqual(unarchivedLink.text, "foo")
    }
}
