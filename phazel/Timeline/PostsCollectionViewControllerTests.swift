//  Created by dasdom on 05/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
import Roaster
@testable import phazel

class PostsCollectionViewControllerTests: XCTestCase {
    
    var container: NSPersistentContainer!
    var sut: PostsCollectionViewController!
    var layout: UICollectionViewFlowLayout!
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        
        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, _ in }
        
        let resultArray: [[String:Any]] = [["id": "42"]]
        layout = UICollectionViewFlowLayout()
        apiClient = MockAPIClient(result: Result(value: resultArray, error: nil))
        sut = PostsCollectionViewController(collectionViewLayout: layout, backgroundContext: container.newBackgroundContext(), apiClient: apiClient)
    }
    
    override func tearDown() {
        container = nil
        layout = nil
        apiClient = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_loadView_loadsPosts() throws {
        expectation(forNotification: NSNotification.Name.NSManagedObjectContextDidSave.rawValue, object: nil, handler: nil)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        waitForExpectations(timeout: 1) { error in
            var posts: [Post] = []
            self.container.viewContext.performAndWait {
                let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
                posts = try! fetchRequest.execute()
            }
            XCTAssertEqual(posts.count, 1)
        }
    }
    
    func test_loadingPosts_callsLoading_WithSinceId() {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: Post.sortedFetchRequest(), managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataSource = CollectionViewDataSourceMock(collectionView: UICollectionView(frame: CGRect.zero, collectionViewLayout: layout), fetchedResultsController: fetchedResultsController, delegate: nil)
        dataSource.storedPost = Post(dict: ["id": "23"], context: container.viewContext)
        sut.dataSource = dataSource
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(apiClient.catchedSince, 23)
    }
}

extension PostsCollectionViewControllerTests {
    
    class CollectionViewDataSourceMock: CollectionViewDataSource<PostsCoordinator> {
        
        var storedPost: Post?
        
        override func object(at indexPath: IndexPath) -> Post {
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
    
    class PersistentContainerMock: NSPersistentContainer {
        
        override func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
            
        }
    }
}
