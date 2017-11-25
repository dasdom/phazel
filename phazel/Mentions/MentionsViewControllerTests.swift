///  Created by dasdom on 24.11.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import Roaster

class MentionsViewControllerTests: XCTestCase {
    
    var sut: MentionsViewController!
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()

        let resultArray: [[String:Any]] = [["id": "123"]]
        apiClient = MockAPIClient(result: Result(value: resultArray, error: nil))
        sut = MentionsViewController(user: User(dict: ["username": "foo", "id": "42"]), apiClient: apiClient)
        _ = sut.view
    }
    
    override func tearDown() {

        sut = nil
        
        super.tearDown()
    }
    
    func test_viewWillAppear_fetchesPosts_withUserId() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(apiClient.lastMentionsUserId, "42")
    }
    
}
