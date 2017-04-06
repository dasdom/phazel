//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class UserTests: XCTestCase {
    
    var container: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, error in
            
        }
    }
    
    override func tearDown() {
        container = nil
        
        super.tearDown()
    }
    
    func test_hasEntity_User() {
        let user = User(context: container.viewContext)
        XCTAssertNotNil(user)
    }
    
    func test_userInit_setsId() {
        let dict = ["id": "23"]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.id, "23")
    }
    
    func test_userInit_setsCreationDate() {
        let dict = ["created_at": "2016-09-09T17:16:39Z"]
        let user = User(dict: dict, context: container.viewContext)
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dict["created_at"]!)
        XCTAssertEqual(user.creationDate, date)
    }
    
    func test_userInit_setsLocale() {
        let dict = ["locale": "en"]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.locale, "en")
    }
    
    func test_userInit_setsTimezone() {
        let dict = ["timezone": "America/Chicago"]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.timezone, "America/Chicago")
    }
    
    func test_userInit_setsType() {
        let dict = ["type": "human"]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.type, "human")
    }
    
    func test_userInit_setsUsername() {
        let dict = ["username": "33MHz"]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.username, "33MHz")
    }
    
    func test_userInit_setsName() {
        let dict = ["name": "Robert"]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.name, "Robert")
    }
    
    func test_userInit_setsFollowsYou() {
        let dict = ["follows_you": true]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.followsYou, true)
    }
    
    func test_userInit_setsYouBlocked() {
        let dict = ["you_blocked": true]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.youBlocked, true)
    }
    
    func test_userInit_setsYouCanFollow() {
        let dict = ["you_can_follow": true]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.youCanFollow, true)
    }
    
    func test_userInit_setsYouMuted() {
        let dict = ["you_muted": true]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.youMuted, true)
    }
    
    func test_userInit_setsCountsBookmarks() {
        let dict = ["counts": ["bookmarks": 23]]
        let user = User(dict: dict, context: container.viewContext)

        XCTAssertEqual(user.numberOfBookmarks, 23)
    }
    
    func test_userInit_setsCountsClients() {
        let dict = ["counts": ["clients": 3]]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.numberOfClients, 3)
    }
    
    func test_userInit_setsCountsFollowers() {
        let dict = ["counts": ["followers": 42]]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.numberOfFollowers, 42)
    }
    
    func test_userInit_setsCountsFollowing() {
        let dict = ["counts": ["following": 42]]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.numberOfFollowing, 42)
    }
    
    func test_userInit_setsCountsPosts() {
        let dict = ["counts": ["posts": 42]]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.numberOfPosts, 42)
    }
    
    func test_userInit_setsCountsUsers() {
        let dict = ["counts": ["users": 42]]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.numberOfUsers, 42)
    }
    
    func test_userInit_setsContentText() {
        let dict = ["content": ["text": "foo"]]
        let user = User(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(user.content?.text, "foo")
        XCTAssertTrue(user.content?.user === user)
    }
}
