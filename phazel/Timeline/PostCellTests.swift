//  Created by dasdom on 20/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class PostCellTests: XCTestCase {
    
    var sut: PostCell!
    var container: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        sut = PostCell()
        
        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, _ in }
    }
    
    override func tearDown() {

        sut = nil
        container = nil
        
        super.tearDown()
    }
    
    func test_has_usernameLableSubview() {
        let usernameLabelIsSubview = sut.usernameLabel.isDescendant(of: sut.contentView)
        XCTAssertTrue(usernameLabelIsSubview)
    }
    
    func test_configure_setsUsername() {
        let dict = ["user": ["username": "foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.usernameLabel.text, "foo")
    }
    
    func test_has_textLabelSubview() {
        let textLabelIsSubview = sut.textLabel.isDescendant(of: sut.contentView)
        XCTAssertTrue(textLabelIsSubview)
    }
    
    func test_configure_setsText() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.textLabel.text, "foo")
    }
    
    func test_has_sourceLabelSubview() {
        let sourceLabelIsSubview = sut.sourceLabel.isDescendant(of: sut.contentView)
        XCTAssertTrue(sourceLabelIsSubview)
    }
    
    func test_configure_setsSource() {
        let dict = ["source": ["name": "Foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.sourceLabel.text, "via Foo")
    }
    
    func test_has_avatarImageViewSubview() {
        let avatarImageViewIsSubview = sut.avatarImageView.isDescendant(of: sut.contentView)
        XCTAssertTrue(avatarImageViewIsSubview)
    }
}
