//  Created by dasdom on 02/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class LinkTests: XCTestCase {
    
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
    
    func test_LinkInit_setsPos() {
        let dict = ["len": 23, "pos": 180]
        let link = Link(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(link.pos, 180)
    }
    
    func test_LinkInit_setsLink() {
        let dict: [String:Any] = ["len": 23, "pos": 180, "link": "http://foo.com"]
        let link = Link(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(link.link, "http://foo.com")
    }
    
    func test_LinkInit_setsText() {
        let dict: [String:Any] = ["len": 23, "pos": 180, "text": "foo"]
        let link = Link(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(link.text, "foo")
    }
}
