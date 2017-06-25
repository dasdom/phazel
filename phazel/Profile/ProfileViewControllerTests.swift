//  Created by dasdom on 04.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import Roaster

class ProfileViewControllerTests: XCTestCase {
    
    var sut: ProfileViewController!
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        
        let resultArray: [[String:Any]] = [["id": "123"]]
        apiClient = MockAPIClient(result: Result(value: resultArray, error: nil))
        sut = ProfileViewController(user: User(dict: ["username": "foo", "id": "42"]), apiClient: apiClient)
        _ = sut.view
    }
    
    override func tearDown() {

        sut = nil
        
        super.tearDown()
    }
    
    func test_view_isProfileView() {
        guard let headerView = sut.tableView.tableHeaderView as? ProfileHeaderView else { return XCTFail() }
        XCTAssertEqual(headerView.usernameLabel.text, "@foo")
    }
    
    func test_viewWillAppear_fetchesPosts_withUserId() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(apiClient.lastProfilePostsUserId, "42")
    }
    
    func test_viewWillAppear_fetchesUser_withUserId() {
//        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
//        dataSourceMock.storedPost = Post(dict: ["id": "23"])
//        sut.dataSource = dataSourceMock
        let result: [String:Any] = ["username": "foobar"]
        apiClient = MockAPIClient(result: Result(value: result, error: nil))
        sut = ProfileViewController(user: User(dict: ["username": "foo", "id": "42"]), apiClient: apiClient)
        
        _ = sut.view
        
        guard let headerView = sut.tableView.tableHeaderView as? ProfileHeaderView else { return XCTFail() }
        XCTAssertEqual(headerView.usernameLabel.text, "@foobar")
    }
    
    func test_followButtonAction_callsFollowMethod_ofAPIClient() {
        sut = ProfileViewController(user: User(dict: ["username": "foo", "id": "42", "you_follow": false]), apiClient: apiClient)
        
        guard let headerView = sut.tableView.tableHeaderView as? ProfileHeaderView else { return XCTFail() }
        headerView.followButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(apiClient.lastFollowValue ?? false)
    }
    
    func test_followButtonAction_callsUnfollowMethod_ofAPIClient() {
        sut = ProfileViewController(user: User(dict: ["username": "foo", "id": "42", "you_follow": true]), apiClient: apiClient)
        
        guard let headerView = sut.tableView.tableHeaderView as? ProfileHeaderView else { return XCTFail() }
        headerView.followButton.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(apiClient.lastFollowValue ?? true)
    }
}
