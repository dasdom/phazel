//  Created by dasdom on 05/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class PostsViewControllerTests: XCTestCase {
    
    var sut: PostsViewController!
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        
        let resultArray: [[String:Any]] = [["id": "42"]]
        apiClient = MockAPIClient(result: Result(value: resultArray, error: nil))
        sut = PostsViewController(apiClient: apiClient)
    
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
}

extension PostsViewControllerTests {
    
    class TableViewDataSourceMock: TableViewDataSource<PostsCoordinator> {
        
        var storedPost: Post?
        var lastIndexPath: IndexPath?
        var addedPosts: [Post]?
        
        override func object(at indexPath: IndexPath) -> Post {
            lastIndexPath = indexPath
            return storedPost!
        }
        
        override func add(posts: [Post]) {
            addedPosts = posts
            super.add(posts: posts)
        }
    }
    
    class MockAPIClient: APIClientProtocol {
        
        let result: Result<[[String:Any]]>
        var catchedBefore: Int?
        var catchedSince: Int?
        
        init(result: Result<[[String:Any]]>) {
            self.result = result
        }
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
            
        }
        
        func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ()) {
        
        }
        
        func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ()) {
            catchedBefore = before
            catchedSince = since
            completion(result)
        }
        
        func isLoggedIn() -> Bool {
            return false
        }
    }
    
    class PostsViewControllerDelegateMock: PostsViewControllerDelegate {
        
        var lastRepliedPost: Post?
        
        func viewDidAppear(viewController: UIViewController) {
            
        }
        
        func reply(to post: Post) {
            lastRepliedPost = post
        }
    }
    
    class TableViewMock: UITableView {
        override func indexPathForRow(at point: CGPoint) -> IndexPath? {
            return IndexPath(row: 1, section: 0)
        }
    }
}
