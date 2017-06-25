//  Created by dasdom on 20.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import Roaster

class GlobalViewControllerTests: XCTestCase {
    
    var sut: GlobalViewController!
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        
        let resultArray: [[String:Any]] = [["id": "123"]]
        apiClient = MockAPIClient(result: Result(value: resultArray, error: nil))
        sut = GlobalViewController(apiClient: apiClient)
        _ = sut.view
    }
    
    override func tearDown() {
        
        sut = nil
        
        super.tearDown()
    }
    
    func test_viewWillAppear_fetchesPosts_withUserId() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "123"])
        sut.dataSource = dataSourceMock
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(apiClient.catchedGlobalSince, 123)
    }
    
}
