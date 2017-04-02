//  Created by dasdom on 02/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class MentionTests: XCTestCase {
    
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

    func test_MentionInit_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let mention = Mention(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(mention.pos, 180)
    }

    func test_MentionInit_setsId() {
        let dict: [String:Any] = ["len": 23, "pos": 180, "id": "42"]
        let mention = Mention(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(mention.id, "42")
    }
    
    func test_MentionInit_setsText() {
        let dict: [String:Any] = ["len": 23, "pos": 180, "text": "foo"]
        let mention = Mention(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(mention.text, "foo")
    }
}
