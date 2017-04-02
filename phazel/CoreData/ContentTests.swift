//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class ContentTests: XCTestCase {
    
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
    
    func test_contentInit_setsId() {
        let dict = ["text": "foo"]
        let content = Content(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(content.text, "foo")
    }
    
    func test_contentInit_setsLinkLen() {
        let dict = ["entities": ["links": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict, context: container.viewContext)

        guard let link = content.links?.first else { return XCTFail() }
        XCTAssertEqual(link.len, 23)
    }
    
    func test_contentInit_setsMentionLen() {
        let dict = ["entities": ["mentions": [["len": 23, "pos": 180]]]]
        let content = Content(dict: dict, context: container.viewContext)
    
        guard let mention = content.mentions?.first else { return XCTFail() }
        XCTAssertEqual(mention.len, 23)
    }
}
