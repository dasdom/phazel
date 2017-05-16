//  Created by dasdom on 02/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class MentionTests: XCTestCase {

    func test_MentionInit_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let mention = Mention(dict: dict)
        
        XCTAssertEqual(mention.pos, 180)
        XCTAssertEqual(mention.len, 23)
    }

    func test_MentionInit_setsId() {
        let dict: [String:Any] = ["id": "42"]
        let mention = Mention(dict: dict)
        
        XCTAssertEqual(mention.id, "42")
    }
    
    func test_MentionInit_setsText() {
        let dict: [String:Any] = ["text": "foo"]
        let mention = Mention(dict: dict)
        
        XCTAssertEqual(mention.text, "foo")
    }
}

//**************************************************
//**************************************************
extension MentionTests {
    func test_unarchive_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let mention = Mention(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: mention)
        guard let unarchivedMention = NSKeyedUnarchiver.unarchiveObject(with: data) as? Mention else { return XCTFail() }
        
        XCTAssertEqual(unarchivedMention.pos, 180)
        XCTAssertEqual(unarchivedMention.len, 23)
    }
    
    func test_unarchive_setsId() {
        let dict: [String:Any] = ["id": "42"]
        let mention = Mention(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: mention)
        guard let unarchivedMention = NSKeyedUnarchiver.unarchiveObject(with: data) as? Mention else { return XCTFail() }
        
        XCTAssertEqual(unarchivedMention.id, "42")
    }
    
    func test_unarchive_setsText() {
        let dict: [String:Any] = ["text": "foo"]
        let mention = Mention(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: mention)
        guard let unarchivedMention = NSKeyedUnarchiver.unarchiveObject(with: data) as? Mention else { return XCTFail() }
        
        XCTAssertEqual(unarchivedMention.text, "foo")
    }
}
