//  Created by dasdom on 18/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class TextSettingsCellTests: XCTestCase {
    
    var sut: TextSettingsCell!
    
    override func setUp() {
        super.setUp()

        sut = TextSettingsCell()
    }
    
    override func tearDown() {

        sut = nil
        
        super.tearDown()
    }
    
    func test_init_withCoder() {
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        
        let localSUT = TextSettingsCell(coder: archiver)
        
        XCTAssertNil(localSUT)
    }

    func test_titleLabel_isDescendant() {
        guard let titleLabel = sut.value(forKey: "titleLabel") as? UILabel else { return XCTFail() }
        
        XCTAssertTrue(titleLabel.isDescendant(of: sut))
    }
    
    func test_valueLabel_isDescendant() {
        guard let valueLabel = sut.value(forKey: "valueLabel") as? UILabel else { return XCTFail() }
        
        XCTAssertTrue(valueLabel.isDescendant(of: sut))
    }

}
