//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class UserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_userInit_setsId() {
        let dict = ["id": "23"]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.id, "23")
    }
    
    func test_userInit_setsCreationDate() {
        let dict = ["created_at": "2016-09-09T17:16:39Z"]
        let user = User(dict: dict)
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dict["created_at"]!)
        XCTAssertEqual(user.creationDate, date)
    }
    
    func test_userInit_setsLocale() {
        let dict = ["locale": "en"]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.locale, "en")
    }
    
    func test_userInit_setsTimezone() {
        let dict = ["timezone": "America/Chicago"]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.timezone, "America/Chicago")
    }
    
    func test_userInit_setsType() {
        let dict = ["type": "human"]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.type, "human")
    }
    
    func test_userInit_setsUsername() {
        let dict = ["username": "33MHz"]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.username, "33MHz")
    }
    
    func test_userInit_setsName() {
        let dict = ["name": "Robert"]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.name, "Robert")
    }
    
    func test_userInit_setsFollowsYou() {
        let dict = ["follows_you": true]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.followsYou, true)
    }
    
    func test_userInit_setsYouFollow() {
        let dict = ["you_follow": true]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.youFollow, true)
    }
    
    func test_userInit_setsYouBlocked() {
        let dict = ["you_blocked": true]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.youBlocked, true)
    }
    
    func test_userInit_setsYouCanFollow() {
        let dict = ["you_can_follow": true]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.youCanFollow, true)
    }
    
    func test_userInit_setsYouMuted() {
        let dict = ["you_muted": true]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.youMuted, true)
    }
    
    func test_userInit_setsCountsBookmarks() {
        let dict = ["counts": ["bookmarks": 23]]
        let user = User(dict: dict)

        XCTAssertEqual(user.numberOfBookmarks, 23)
    }
    
    func test_userInit_setsCountsClients() {
        let dict = ["counts": ["clients": 3]]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.numberOfClients, 3)
    }
    
    func test_userInit_setsCountsFollowers() {
        let dict = ["counts": ["followers": 42]]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.numberOfFollowers, 42)
    }
    
    func test_userInit_setsCountsFollowing() {
        let dict = ["counts": ["following": 42]]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.numberOfFollowing, 42)
    }
    
    func test_userInit_setsCountsPosts() {
        let dict = ["counts": ["posts": 42]]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.numberOfPosts, 42)
    }
    
    func test_userInit_setsCountsUsers() {
        let dict = ["counts": ["users": 42]]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.numberOfUsers, 42)
    }
    
    func test_userInit_setsContentText() {
        let dict = ["content": ["text": "foo"]]
        let user = User(dict: dict)
        
        XCTAssertEqual(user.content?.text, "foo")
        XCTAssertTrue(user.content?.user === user)
    }
    
}

//**************************************************
//**************************************************
extension UserTests {
    func test_unarchive_setsId() {
        let dict = ["id": "23"]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.id, "23")
    }
    
    func test_unarchive_setsCreationDate() {
        let dict = ["created_at": "2016-09-09T17:16:39Z"]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dict["created_at"]!)
        XCTAssertEqual(unarchivedUser.creationDate, date)
    }
    
    func test_unarchive_setsLocale() {
        let dict = ["locale": "en"]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.locale, "en")
    }
    
    func test_unarchive_setsTimezone() {
        let dict = ["timezone": "America/Chicago"]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.timezone, "America/Chicago")
    }
    
    func test_unarchive_setsType() {
        let dict = ["type": "human"]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.type, "human")
    }
    
    func test_unarchive_setsUsername() {
        let dict = ["username": "33MHz"]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.username, "33MHz")
    }
    
    func test_unarchive_setsName() {
        let dict = ["name": "Robert"]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.name, "Robert")
    }
    
    func test_unarchive_setsFollowsYou() {
        let dict = ["follows_you": true]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.followsYou, true)
    }
    
    func test_unarchive_setsYouFollow() {
        let dict = ["you_follow": true]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.youFollow, true)
    }
    
    func test_unarchive_setsYouBlocked() {
        let dict = ["you_blocked": true]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.youBlocked, true)
    }
    
    func test_unarchive_setsYouCanFollow() {
        let dict = ["you_can_follow": true]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.youCanFollow, true)
    }
    
    func test_unarchive_setsYouMuted() {
        let dict = ["you_muted": true]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.youMuted, true)
    }
    
    func test_unarchive_setsCountsBookmarks() {
        let dict = ["counts": ["bookmarks": 23]]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.numberOfBookmarks, 23)
    }
    
    func test_unarchive_setsCountsClients() {
        let dict = ["counts": ["clients": 3]]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.numberOfClients, 3)
    }
    
    func test_unarchiver_setsCountsFollowers() {
        let dict = ["counts": ["followers": 42]]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.numberOfFollowers, 42)
    }
    
    func test_unarchive_setsCountsFollowing() {
        let dict = ["counts": ["following": 42]]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.numberOfFollowing, 42)
    }
    
    func test_unarchive_setsCountsPosts() {
        let dict = ["counts": ["posts": 42]]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.numberOfPosts, 42)
    }
    
    func test_unarchive_setsCountsUsers() {
        let dict = ["counts": ["users": 42]]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.numberOfUsers, 42)
    }
    
    func test_unarchive_setsContentText() {
        let dict = ["content": ["text": "foo"]]
        let user = User(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        guard let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else { return XCTFail() }
        
        XCTAssertEqual(unarchivedUser.content?.text, "foo")
        XCTAssertTrue(unarchivedUser.content?.user === unarchivedUser)
    }
}
