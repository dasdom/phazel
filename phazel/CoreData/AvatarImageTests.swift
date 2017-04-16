//  Created by dasdom on 14/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class AvatarImageTests: XCTestCase {
    
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
    
    func test_ImageInit_setsWidth() {
        let dict = ["width": 23]
        let image = CoverImage(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(image.width, 23)
    }
    
    func test_ImageInit_setsHeight() {
        let dict = ["height": 42]
        let image = CoverImage(dict: dict, context: container.viewContext)
        
        XCTAssertEqual(image.height, 42)
    }
    
}
