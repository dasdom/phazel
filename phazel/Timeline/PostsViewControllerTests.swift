//  Created by dasdom on 05/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class PostsViewControllerTests: XCTestCase {
    
    var sut: PostsViewController!
    var apiClient: MockAPIClient!
    var delegate: PostsViewControllerDelegateMock!
    
    override func setUp() {
        super.setUp()
        
        let resultArray: [[String:Any]] = [["id": "42"]]
        apiClient = MockAPIClient(result: Result(value: resultArray, error: nil))
        sut = PostsViewController(apiClient: apiClient)
        delegate = PostsViewControllerDelegateMock()
        sut.delegate = delegate
    }
    
    override func tearDown() {
        apiClient = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_viewWillAppear_fetchesPosts_withSinceId() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(apiClient.catchedSince, 23)
    }
    
    func test_fetchedPosts_areSentToDataSource() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(dataSourceMock.addedPosts?.count, 1)
    }
    
    func test_serializesPosts_inWillDisappear() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        dataSourceMock.dataArray = []
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let newSUT = PostsViewController(apiClient: apiClient)
        let newDataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        newSUT.dataSource = newDataSourceMock
        
        XCTAssertEqual(newSUT.dataSource?.dataArray.count, 1)
    }
    
    func test_link_atOffset_returnsLink() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23", "content": ["text": "foo", "entities": ["links": [["len": 23, "pos": 180, "link": "http://foo.com"]]]]])
        sut.dataSource = dataSourceMock
        
        let returnedLink = sut.link(for: 180, at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(returnedLink?.link, "http://foo.com")
    }
    
    func test_reply_callsReply_inDelegate() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        
        let cell = sut.dataSource?.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! PostCell
        cell.replyButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(delegate.lastRepliedPost?.id, "23")
    }
    
    func test_showProfile_callsShowProfile_inDelegate() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        
        let cell = sut.dataSource?.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! PostCell
        cell.profileButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(delegate.lastShowProfilePost?.id, "23")
    }
    
    func test_showThread_callsShowThread_inDelegate() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["thread_id": "23"])
        sut.dataSource = dataSourceMock
        
        let cell = sut.dataSource?.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! PostCell
        cell.threadButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(delegate.lastShowThreadPost?.threadId, "23")
    }
}

// MARK: - Mocks
extension PostsViewControllerTests {
    
    class TableViewMock: UITableView {
        override func indexPathForRow(at point: CGPoint) -> IndexPath? {
            return IndexPath(row: 1, section: 0)
        }
    }
}
