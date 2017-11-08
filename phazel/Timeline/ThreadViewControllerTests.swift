//  Created by dasdom on 22.10.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class ThreadViewControllerTests: XCTestCase {
    
    var sut: ThreadViewController!
    var apiClient: MockAPIClient!
    var delegate: PostsViewControllerDelegateMock!
    
    override func setUp() {
        super.setUp()

        let resultArray: [[String:Any]] = [["id": "42"]]
        apiClient = MockAPIClient(result: Result(value: resultArray, error: nil))
        let post = Post(dict: ["thread_id": "23"])
        sut = ThreadViewController(post: post, apiClient: apiClient)
        delegate = PostsViewControllerDelegateMock()
        sut.delegate = delegate
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_viewWillAppear_fetchesPosts_withSinceId() {
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(apiClient.catchedPostId, 23)
    }
    
    func test_fetchedPosts_areSentToDataSource() {
        let dataSourceMock = TableViewDataSourceMock(tableView: sut.tableView, delegate: nil)
        dataSourceMock.storedPost = Post(dict: ["id": "23"])
        sut.dataSource = dataSourceMock
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(dataSourceMock.addedPosts?.count, 1)
    }
}
