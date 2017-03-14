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
    
    func test_itemForIndexPath_returnsAccountSetting_1() {
        let settingsItem = SettingsItem.string("Foo", "Bar")
        let localSUT = SettingsViewController(settingsItems: [settingsItem])
        
        let returnedSettingsItem = localSUT.item(for: IndexPath(row: 0, section: 0))
    
        XCTAssertEqual(returnedSettingsItem, settingsItem)
    }
    
    func test_itemForIndexPath_returnsAccountSetting_2() {
        let settingsItem = SettingsItem.string("Account", "foobar")
        let localSUT = SettingsViewController(settingsItems: [settingsItem])
        
        let returnedSettingsItem = localSUT.item(for: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(returnedSettingsItem, settingsItem)
    }
    
    func test_cellForItemAtIndexPath_returnsCellWithTitle_1() {
        let settingsItem = SettingsItem.string("Foo", "Bar")
        let localSUT = SettingsViewController(settingsItems: [settingsItem])
        
        let cell = localSUT.cell(forItemAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? TextSettingsCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Foo")
    }
    
    func test_cellForItemAtIndexPath_returnsCellWithTitle_2() {
        let settingsItem = SettingsItem.string("Account", "foobar")
        let localSUT = SettingsViewController(settingsItems: [settingsItem])
        
        let cell = localSUT.cell(forItemAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? TextSettingsCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Account")
        XCTAssertEqual(unwrappedCell.valueLabel.text, "foobar")
    }
    
    func test_cellForRowAtIndexPath_callsCellForItem() {
        let settingsItem = SettingsItem.string("Account", "foobar")
        let localSUT = SettingsViewControllerMock(settingsItems: [settingsItem])
        
        _ = localSUT.tableView(localSUT.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(localSUT.indexPathOfDemandedCell, IndexPath(row: 0, section: 0))
    }
    
    func test_selectingACell_callsDelegateMethod() {
        let delegate = SettingsViewControllerDelegateMock()
        sut.delegate = delegate
        
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(delegate.selectedIndexPath, IndexPath(row: 1, section: 0))
    }
}

// MARK: - Mocks
extension SettingsViewControllerTests {
    class SettingsViewControllerMock: SettingsViewController {
        
        var indexPathOfDemandedCell: IndexPath?
        
        override func cell(forItemAt indexPath: IndexPath) -> UITableViewCell {
            indexPathOfDemandedCell = indexPath
            return super.cell(forItemAt: indexPath)
        }
    }
    
    class SettingsViewControllerDelegateMock: SettingsViewControllerDelegate {
        
        var selectedIndexPath: IndexPath?
        
        func didSetSettingsFor<T>(key: String, withValue: T?) {
            
        }
        
        func didSelect(rowAt indexPath: IndexPath) {
            selectedIndexPath = indexPath
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
