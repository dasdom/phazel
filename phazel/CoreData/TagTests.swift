//  Created by dasdom on 03/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class TagTests: XCTestCase {
                
    func test_TagInit_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let tag = Tag(dict: dict)
        
        XCTAssertEqual(tag.pos, 180)
        XCTAssertEqual(tag.len, 23)
    }
    
    func test_TagInit_setsText() {
        let dict: [String:Any] = ["text": "foo"]
        let tag = Tag(dict: dict)
        
        XCTAssertEqual(tag.text, "foo")
    }
}

//**************************************************
//**************************************************
extension TagTests {
    func test_unarchive_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let tag = Tag(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: tag)
        guard let unarchivedTag = NSKeyedUnarchiver.unarchiveObject(with: data) as? Tag else { return XCTFail() }
        
        XCTAssertEqual(unarchivedTag.pos, 180)
        XCTAssertEqual(unarchivedTag.len, 23)
    }
    
    func test_unarchive_setsText() {
        let dict: [String:Any] = ["text": "foo"]
        let tag = Tag(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: tag)
        guard let unarchivedTag = NSKeyedUnarchiver.unarchiveObject(with: data) as? Tag else { return XCTFail() }
        
        XCTAssertEqual(unarchivedTag.text, "foo")
    }
}
