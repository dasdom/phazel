//  Created by dasdom on 08/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class SettingsViewControllerTests: XCTestCase {
    
    var sut: SettingsViewController!
    
    override func setUp() {
        super.setUp()
        
        sut = SettingsViewController(settingsItems: [])
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_itemForIndexPath_returnsAccountSetting() {
        
        let settingsItem = sut.item(for: NSIndexPath(row: 0, section: 0))
    
        let expectedSettingsItem = SettingsItem.string("Account", "foobar")
        XCTAssertEqual(settingsItem, expectedSettingsItem)
    }
    
    func test_cellForItemAtIndexPath_returnsAccountCell() {
        
        let cell = sut.cell(forItemAt: NSIndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TextSettingsCell)
    }
}

extension SettingsItem: Equatable {
    public static func ==(lhs: SettingsItem, rhs: SettingsItem) -> Bool {
        switch (lhs, rhs) {
        case let (.string(ltitle, lvalue), .string(rtitle, rvalue)):
            return ltitle == rtitle && lvalue == rvalue
        case let (.boolean(ltitle, lvalue), .boolean(rtitle, rvalue)):
            return ltitle == rtitle && lvalue == rvalue
        default:
            return false
        }
    }
}
