//  Created by dasdom on 05/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class PostTests: XCTestCase {
    
    func test_init_setsId() {
        let dict = ["id": "23"]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.id, "23")
    }
    
    func test_init_setsCreationDate() {
        let dict = ["created_at": "2016-09-09T17:16:39Z"]
        let post = Post(dict: dict)
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dict["created_at"]!)
        XCTAssertEqual(post.creationDate, date)
    }
    
    func test_init_setsReplyTo() {
        let dict = ["reply_to": "42"]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.replyTo, "42")
    }
    
    func test_init_setsThreadId() {
        let dict = ["thread_id": "123"]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.threadId, "123")
    }
    
    func test_init_setsYouBookmarked() {
        let dict = ["you_bookmarked": true]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.youBookmarked, true)
    }
    
    func test_init_setsYouReposted() {
        let dict = ["you_reposted": true]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.youReposted, true)
    }
    
    func test_init_setsCountsBookmarks() {
        let dict = ["counts": ["bookmarks": 23]]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.numberOfBookmarks, 23)
    }
    
    func test_init_setsCountsReplies() {
        let dict = ["counts": ["replies": 23]]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.numberOfReplies, 23)
    }
    
    func test_init_setsCountsReposts() {
        let dict = ["counts": ["reposts": 23]]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.numberOfReposts, 23)
    }
    
    func test_init_setsCountsThreads() {
        let dict = ["counts": ["threads": 23]]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.numberOfThreads, 23)
    }
    
    func test_init_setsSourceLink() {
        let dict = ["source": ["link": "foo"]]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.sourceLink, "foo")
    }
    
    func test_init_setsSourceName() {
        let dict = ["source": ["name": "Foo"]]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.sourceName, "Foo")
    }
    
    func test_init_setsContentText() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict)

        XCTAssertEqual(post.content?.text, "foo")
        XCTAssertTrue(post.content?.post === post)
    }
    
    func test_init_setsUserId() {
        let dict = ["user": ["id": "23"]]
        let post = Post(dict: dict)
        
        XCTAssertEqual(post.user?.id, "23")
        XCTAssertTrue(post.user?.post === post)
    }
}

//**************************************************
//**************************************************
extension PostTests {
    func test_unarchive_setsId() {
        let dict = ["id": "23"]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.id, "23")
    }
    
    func test_unarchive_setsCreationDate() {
        let dict = ["created_at": "2016-09-09T17:16:39Z"]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dict["created_at"]!)
        XCTAssertEqual(unarchivedPost.creationDate, date)
    }
    
    func test_unarchive_setsReplyTo() {
        let dict = ["reply_to": "42"]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.replyTo, "42")
    }
    
    func test_unarchive_setsThreadId() {
        let dict = ["thread_id": "123"]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.threadId, "123")
    }
    
    func test_unarchive_setsYouBookmarked() {
        let dict = ["you_bookmarked": true]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.youBookmarked, true)
    }
    
    func test_unarchive_setsYouReposted() {
        let dict = ["you_reposted": true]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.youReposted, true)
    }
    
    func test_unarchive_setsCountsBookmarks() {
        let dict = ["counts": ["bookmarks": 23]]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.numberOfBookmarks, 23)
    }
    
    func test_unarchive_setsCountsReplies() {
        let dict = ["counts": ["replies": 23]]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.numberOfReplies, 23)
    }
    
    func test_unarchive_setsCountsReposts() {
        let dict = ["counts": ["reposts": 23]]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.numberOfReposts, 23)
    }
    
    func test_unarchive_setsCountsThreads() {
        let dict = ["counts": ["threads": 23]]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.numberOfThreads, 23)
    }
    
    func test_unarchive_setsSourceLink() {
        let dict = ["source": ["link": "foo"]]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.sourceLink, "foo")
    }
    
    func test_unarchive_setsSourceName() {
        let dict = ["source": ["name": "Foo"]]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.sourceName, "Foo")
    }
    
    func test_unarchive_setsContentText() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: post)
        guard let unarchivedPost = NSKeyedUnarchiver.unarchiveObject(with: data) as? Post else { return XCTFail() }
        
        XCTAssertEqual(unarchivedPost.content?.text, "foo")
        XCTAssertTrue(unarchivedPost.content?.post === unarchivedPost)
    }
}
