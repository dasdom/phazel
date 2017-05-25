//  Created by dasdom on 25/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class TableViewDataSourceTests: XCTestCase {
    
    var sut: TableViewDataSource<TableViewDataSourceDelegateMock>!
    var tableView: TableViewMock!
    var delegate: TableViewDataSourceDelegateMock!

    override func setUp() {
        super.setUp()

        tableView = TableViewMock(frame: CGRect(x: 0, y: 0, width: 300, height: 300), style: .plain)
        
        delegate = TableViewDataSourceDelegateMock()
        sut = TableViewDataSource(tableView: tableView, delegate: delegate)
    }
    
    override func tearDown() {
        sut = nil
        tableView = nil
        delegate = nil
        
        super.tearDown()
    }
    
    func test_isDataSource_ofTableView() {
        XCTAssertTrue(sut === tableView.dataSource)
    }
    
    func test_init_setDelegate() {
        XCTAssertNotNil(sut.delegate)
    }
    
    func test_init_callsRegisterCellClass() {
        XCTAssertTrue(tableView.cellClass == PostCellMock.self)
    }
    
    func test_numberOfItems_isNumberOfPosts_1() {
        let post = Post(dict: ["id": "23"])
        sut.dataArray = [post]
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_numberOfItems_isNumberOfPosts_2() {
        let post1 = Post(dict: ["id": "23"])
        let post2 = Post(dict: ["id": "42"])
        sut.dataArray = [post1, post2]
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_cellForRowAtIndexPath_callsConfigure_onDelegate() {
        let post = Post(dict: ["id": "23"])
        sut.dataArray = [post]
        
        _ = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(delegate.lastPost, post)
        XCTAssertNotNil(delegate.lastCell)
    }
    
    func test_addPosts_addsPosts() {
        let post = Post(dict: ["id": "23"])
        sut.dataArray = [post]
        
        sut.add(posts: [Post(dict: ["id": "42"])])
        
        XCTAssertEqual(sut.dataArray.count, 2)
    }
    
    func test_addPosts_removesOldPosts_ifCountIsGreaterThan200() {
        var posts = [Post]()
        for i in 0..<1000 {
            let post = Post(dict: ["id": "\(i)"])
            posts.append(post)
        }
        sut.dataArray = posts
        XCTAssertEqual(sut.dataArray.count, 1000)

        sut.add(posts: [Post(dict: ["id": "42"])])
        
        XCTAssertEqual(sut.dataArray.first?.id, "42")
        XCTAssertEqual(sut.dataArray.count, 1000)
    }
}

// *********************************
// MARK: - Mock
extension TableViewDataSourceTests {
    class TableViewDataSourceDelegateMock: TableViewDataSourceDelegate {
        
        var lastCell: PostCellMock?
        var lastPost: Post?
        
        func configure(_ cell: PostCellMock, for object: Post) {
            lastCell = cell
            lastPost = object
        }
    }
    
    class PostCellMock: PostCell {
        
        var postToConfigureFor: Post?
        
        override func configure(with post: Post, loadImage: Bool = true) {
            postToConfigureFor = post
        }
    }
    
    class TableViewMock: UITableView {
        
        var beginUpdatesCallCount = 0
        var endUpdatesCallCount = 0
        var lastInsertedRows: [IndexPath]?
        var lastDeletedRows: [IndexPath]?
        var cellClass: AnyClass?
        
        override func beginUpdates() {
            beginUpdatesCallCount += 1
        }
        
        override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
            
            lastInsertedRows = indexPaths
        }
        
        override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
            
            lastDeletedRows = indexPaths
        }
        
        override func endUpdates() {
            
            endUpdatesCallCount += 1
        }
        
        override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
            
            self.cellClass = cellClass
            super.register(cellClass, forCellReuseIdentifier: identifier)
        }
    }
}
