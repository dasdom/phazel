//  Created by dasdom on 19/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import Roaster

class AccountsViewControllerTests: XCTestCase {
    
    var sut: AccountsViewController!
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_init_withCoder() {
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        
        let localSUT = AccountsViewController(coder: archiver)
        
        XCTAssertNil(localSUT)
    }
    
    func test_cellForRowAt_returnsCell_1() {
        let localSUT = AccountsViewController(accounts: [LoginUser(id: "23", username: "Foo")])
        
        let cell = localSUT.tableView(localSUT.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? AccountCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Foo")
    }
    
    func test_cellForRowAt_returnsCell_2() {
        let localSUT = AccountsViewController(accounts: [LoginUser(id: "42", username: "Bar")])
        
        let cell = localSUT.tableView(localSUT.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? AccountCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Bar")
    }
}
