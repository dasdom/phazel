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
    
    func test_has_collectionViewDataSource() {
        let dataSource = CollectionViewDataSourceMock()
        let localSUT = PostsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), dataSource: dataSource, persistentContainer: container, apiClient: MockAPIClient())
        _ = localSUT.view
        
        XCTAssertTrue(localSUT.collectionView?.dataSource === dataSource)
    }
    
    func test_loadView_callsURL() {
        let responseDict = ["data":[["id": "42"]]]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        URLRequestStub.stub(data: responseData, expect: expectation(description: "Post request"))
        let dataSource = CollectionViewDataSourceMock()
        let localSUT = PostsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), dataSource: dataSource, persistentContainer: container, apiClient: APIClient(userDefaults: UserDefaults()))
        
        _ = localSUT.view
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(URLRequestStub.lastURLComponents()?.path, "/v0/posts/streams/unified")
        }
    }
    
    func test_loadView_loadsPosts() throws {
        let responseDict = ["data":[["id": "42"]]]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        URLRequestStub.stub(data: responseData, expect: expectation(description: "Post request"))
        let dataSource = CollectionViewDataSourceMock()
        let localSUT = PostsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), dataSource: dataSource, persistentContainer: container, apiClient: APIClient(userDefaults: UserDefaults()))
        
        _ = localSUT.view
        
        self.container.viewContext.perform {
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            let posts = try! fetchRequest.execute()
            
            XCTAssertEqual(posts.count, 1)
        }
        waitForExpectations(timeout: 1) { error in
            
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
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
            
        }
        
        func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ()) {
        
        }
        
        func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ()) {
            
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
