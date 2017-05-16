//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class ImageTests: XCTestCase {
    
    func test_init_setsWidth() {
        let dict = ["width": 23]
        let image = Image(dict: dict)
        
        XCTAssertEqual(image.width, 23)
    }
    
    func test_init_setsHeight() {
        let dict = ["height": 42]
        let image = Image(dict: dict)
        
        XCTAssertEqual(image.height, 42)
    }
    
    func test_init_setsLink() {
        let dict = ["link": "foo"]
        let image = Image(dict: dict)
        
        XCTAssertEqual(image.link, "foo")
    }
}

//**************************************************
//**************************************************
extension ImageTests {
    func test_unarchive_setsWidth() {
        let dict = ["width": 23]
        let image = Image(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: image)
        guard let unarchivedImage = NSKeyedUnarchiver.unarchiveObject(with: data) as? Image else { return XCTFail() }
        
        XCTAssertEqual(unarchivedImage.width, 23)
    }
    
    func test_unarchive_setsHeight() {
        let dict = ["height": 42]
        let image = Image(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: image)
        guard let unarchivedImage = NSKeyedUnarchiver.unarchiveObject(with: data) as? Image else { return XCTFail() }
        
        XCTAssertEqual(unarchivedImage.height, 42)
    }
    
    func test_unarchive_setsLink() {
        let dict = ["link": "foo"]
        let image = Image(dict: dict)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: image)
        guard let unarchivedImage = NSKeyedUnarchiver.unarchiveObject(with: data) as? Image else { return XCTFail() }
        
        XCTAssertEqual(unarchivedImage.link, "foo")
    }
}
