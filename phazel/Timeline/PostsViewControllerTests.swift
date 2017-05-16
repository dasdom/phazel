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
    
    func test_loadView_loadsPosts() throws {
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        
    }
    
}

extension PostsViewControllerTests {
    
    class TableViewDataSourceMock: TableViewDataSource<PostsCoordinator> {
        
        var storedPost: Post?
        var lastIndexPath: IndexPath?
        
        override func object(at indexPath: IndexPath) -> Post {
            lastIndexPath = indexPath
            return storedPost!
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
