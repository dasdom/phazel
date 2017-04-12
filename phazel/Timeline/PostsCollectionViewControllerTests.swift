//  Created by dasdom on 05/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
import Roaster
@testable import phazel

class PostsCollectionViewControllerTests: XCTestCase {
    
    var container: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, error in
            
        }
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
//    func test_has_collectionViewDataSource() {
//        let localSUT = PostsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), backgroundContext: container.newBackgroundContext(), apiClient: MockAPIClient(result: Result(value: nil, error: nil)))
//        _ = localSUT.view
//        
//        XCTAssertTrue(localSUT.collectionView?.dataSource is CollectionViewDataSource)
//    }
    
    func test_loadView_loadsPosts() throws {
        let resultArray: [[String:Any]] = [["id": "42"]]
        let localSUT = PostsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), backgroundContext: container.newBackgroundContext(), apiClient: MockAPIClient(result: Result(value: resultArray, error: nil)))
        expectation(forNotification: NSNotification.Name.NSManagedObjectContextDidSave.rawValue, object: nil, handler: nil)
        
        _ = localSUT.view
        
        waitForExpectations(timeout: 1) { error in
            var posts: [Post] = []
            self.container.viewContext.performAndWait {
                let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
                posts = try! fetchRequest.execute()
            }
            XCTAssertEqual(posts.count, 1)
        }
    }
}

extension PostsCollectionViewControllerTests {
    class CollectionViewDataSourceMock: NSObject, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 0
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
    }
    
    class MockAPIClient: APIClientProtocol {
        
        let result: Result<[[String:Any]]>
        
        init(result: Result<[[String:Any]]>) {
            self.result = result
        }
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
            
        }
        
        func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ()) {
        
        }
        
        func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ()) {
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
