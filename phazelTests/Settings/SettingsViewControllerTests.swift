//  Created by dasdom on 08/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class SettingsViewControllerTests: XCTestCase {
    
    var sut: SettingsViewController!
    
    override func setUp() {
        super.setUp()

        sut = SettingsViewController()
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_hasUserSettingsItem() {
        
        let settingsContainsUser = sut.settingsItems.contains(where: { settingsItem -> Bool in
            return settingsItem.title == "Active Account"
        })
        
        XCTAssertTrue(settingsContainsUser)
    }
}
