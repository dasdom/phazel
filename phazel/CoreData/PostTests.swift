//  Created by dasdom on 05/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class PostTests: XCTestCase {
    
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
    
    func test_postInit_setsId() {
        let dict = ["id": "23"]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.id, "23")
    }
    
    func test_postInit_setsCreationDate() {
        let dict = ["created_at": "2016-09-09T17:16:39Z"]
        let post = Post(dict: dict, context: container.viewContext)
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dict["created_at"]!)
        XCTAssertEqual(post.creationDate, date)
    }
    
    func test_postInit_setsReplyTo() {
        let dict = ["reply_to": "42"]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.replyTo, "42")
    }
    
    func test_postInit_setsThreadId() {
        let dict = ["thread_id": "123"]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.threadId, "123")
    }
    
    func test_postInit_setsYouBookmarked() {
        let dict = ["you_bookmarked": true]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.youBookmarked, true)
    }
    
    func test_postInit_setsYouReposted() {
        let dict = ["you_reposted": true]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.youReposted, true)
    }
    
    func test_userInit_setsCountsBookmarks() {
        let dict = ["counts": ["bookmarks": 23]]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.numberOfBookmarks, 23)
    }
    
    func test_userInit_setsCountsReplies() {
        let dict = ["counts": ["replies": 23]]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.numberOfReplies, 23)
    }
    
    func test_userInit_setsCountsReposts() {
        let dict = ["counts": ["reposts": 23]]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.numberOfReposts, 23)
    }
    
    func test_userInit_setsCountsThreads() {
        let dict = ["counts": ["threads": 23]]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.numberOfThreads, 23)
    }
    
    func test_userInit_setsSourceLink() {
        let dict = ["source": ["link": "foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.sourceLink, "foo")
    }
    
    func test_userInit_setsSourceName() {
        let dict = ["source": ["name": "Foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.sourceName, "Foo")
    }
    
    func test_postInit_setsContentText() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict, context: container.viewContext)

        XCTAssertEqual(post.content?.text, "foo")
        XCTAssertTrue(post.content?.post === post)
    }
    
    func test_postInit_setsUserId() {
        let dict = ["user": ["id": "23"]]
        let post = Post(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(post.user?.id, "23")
        XCTAssertTrue(post.user?.post === post)
    }
}
