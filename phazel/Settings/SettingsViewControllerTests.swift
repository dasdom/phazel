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
    
    func test_cellForRowAtIndexPath_returnsCell_1() {
        let settingsItem = SettingsItem.string("Account", "foobar")
        let localSUT = SettingsViewController(settingsItems: [settingsItem])
        
        let cell = localSUT.tableView(localSUT.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? TextSettingsCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Account")
        XCTAssertEqual(unwrappedCell.valueLabel.text, "foobar")
    }
    
    func test_cellForRowAtIndexPath_returnsCell_2() {
        let settingsItem = SettingsItem.string("Foo", "Bar")
        let localSUT = SettingsViewController(settingsItems: [settingsItem])
        
        let cell = localSUT.tableView(localSUT.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? TextSettingsCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Foo")
        XCTAssertEqual(unwrappedCell.valueLabel.text, "Bar")
    }
    
    func test_selectingACell_callsDelegateMethod() {
        let delegate = SettingsViewControllerDelegateMock()
        let settingsItem = SettingsItem.string("Foo", "Bar")
        let localSUT = SettingsViewController(settingsItems: [settingsItem])
        localSUT.delegate = delegate
        
        localSUT.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(delegate.selectedSettingsItem, settingsItem)
    }
}

// MARK: - Mocks
extension SettingsViewControllerTests {
    
    class SettingsViewControllerDelegateMock: SettingsViewControllerDelegate {
        
        var selectedSettingsItem: SettingsItem?
        
        func didSelect(_ viewController: SettingsViewController, settingsItem: SettingsItem) {
            selectedSettingsItem = settingsItem
        }
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
