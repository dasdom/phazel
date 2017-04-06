//  Created by dasdom on 03/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class TagTests: XCTestCase {
    
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
    
    func test_TagInit_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let tag = Tag(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(tag.pos, 180)
    }
    
    func test_TagInit_setsText() {
        let dict: [String:Any] = ["len": 23, "pos": 180, "text": "foo"]
        let tag = Tag(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(tag.text, "foo")
    }
}
