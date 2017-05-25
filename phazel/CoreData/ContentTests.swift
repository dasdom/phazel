//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class ContentTests: XCTestCase {
    
    func test_contentInit_setsText() {
        let dict = ["text": "foo"]
        let content = Content(dict: dict)
        
        XCTAssertEqual(content.text, "foo")
    }
    
    func test_contentInit_setsLinkLen() {
        let dict = ["entities": ["links": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict)

        guard let link = content.links?.first else { return XCTFail() }
        XCTAssertEqual(link.len, 23)
    }
    
    func test_contentInit_setsMentionLen() {
        let dict = ["entities": ["mentions": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict)
    
        guard let mention = content.mentions?.first else { return XCTFail() }
        XCTAssertEqual(mention.len, 23)
    }
    
    func test_contentInit_setsTagsLen() {
        let dict = ["entities": ["tags": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict)
        
        guard let tag = content.tags?.first else { return XCTFail() }
        XCTAssertEqual(tag.len, 23)
    }
    
    func test_contentInit_setsAvatarImageLink() {
        let dict = ["avatar_image": ["link": "foo"]]
        let content = Content(dict: dict)
        
        XCTAssertEqual(content.avatarImage?.link, "foo")
        XCTAssertEqual(content.avatarImage?.content, content)
    }

    func test_contentInit_setsCoverImageLink() {
        let dict = ["cover_image": ["link": "bar"]]
        let content = Content(dict: dict)
        
        XCTAssertEqual(content.coverImage?.link, "bar")
        XCTAssertEqual(content.coverImage?.content, content)
    }

}

//**************************************************
//**************************************************
extension ContentTests {
    func test_unarchive_setsText() {
        let dict = ["text": "foo"]
        let content = Content(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: content)
        guard let unarchivedContent = NSKeyedUnarchiver.unarchiveObject(with: data) as? Content else { return XCTFail() }
        
        XCTAssertEqual(unarchivedContent.text, "foo")
    }
    
    func test_unarchive_setsLinkLen() {
        let dict = ["entities": ["links": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: content)
        guard let unarchivedContent = NSKeyedUnarchiver.unarchiveObject(with: data) as? Content else { return XCTFail() }
        
        guard let link = unarchivedContent.links?.first else { return XCTFail() }
        XCTAssertEqual(link.len, 23)
    }
    
    func test_unarchive_setsMentionLen() {
        let dict = ["entities": ["mentions": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: content)
        guard let unarchivedContent = NSKeyedUnarchiver.unarchiveObject(with: data) as? Content else { return XCTFail() }
        
        guard let mention = unarchivedContent.mentions?.first else { return XCTFail() }
        XCTAssertEqual(mention.len, 23)
    }
    
    func test_unarchive_setsTagsLen() {
        let dict = ["entities": ["tags": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: content)
        guard let unarchivedContent = NSKeyedUnarchiver.unarchiveObject(with: data) as? Content else { return XCTFail() }
        
        guard let tag = unarchivedContent.tags?.first else { return XCTFail() }
        XCTAssertEqual(tag.len, 23)
    }
    
    func test_unarchive_setsAvatarImageLink() {
        let dict = ["avatar_image": ["link": "foo"]]
        let content = Content(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: content)
        guard let unarchivedContent = NSKeyedUnarchiver.unarchiveObject(with: data) as? Content else { return XCTFail() }
        
        XCTAssertEqual(unarchivedContent.avatarImage?.link, "foo")
        XCTAssertEqual(unarchivedContent.avatarImage?.content, unarchivedContent)
    }

    func test_unarchive_setsCoverImageLink() {
        let dict = ["cover_image": ["link": "bar"]]
        let content = Content(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: content)
        guard let unarchivedContent = NSKeyedUnarchiver.unarchiveObject(with: data) as? Content else { return XCTFail() }
        
        XCTAssertEqual(unarchivedContent.coverImage?.link, "bar")
        XCTAssertEqual(unarchivedContent.coverImage?.content, unarchivedContent)
    }
}
