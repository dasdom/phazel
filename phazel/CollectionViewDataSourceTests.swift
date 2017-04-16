//  Created by dasdom on 10/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
@testable import phazel

class CollectionViewDataSourceTests: XCTestCase {
    
    var sut: CollectionViewDataSource<CollectionViewDataSourceDelegateMock>!
    var collectionView: UICollectionView!
    var container: NSPersistentContainer!
    var fetchedResultsController: FetchedResultsControllerMock!

    override func setUp() {
        super.setUp()

        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, _ in }

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
        fetchedResultsController = FetchedResultsControllerMock(fetchRequest: Post.sortedFetchRequest(), managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        sut = CollectionViewDataSource(collectionView: collectionView, fetchedResultsController: fetchedResultsController, delegate: CollectionViewDataSourceDelegateMock())
    }
    
    override func tearDown() {
        sut = nil
        container = nil
        
        super.tearDown()
    }
    
    func test_isDataSource_ofCollectionView() {
        XCTAssertTrue(sut === collectionView.dataSource)
    }
    
    func test_init_setsFetchedResultController() {
        XCTAssertEqual(sut.fetchedResultsController, fetchedResultsController)
    }
    
    func test_init_setDelegate() {
        XCTAssertNotNil(sut.delegate)
    }
    
    func test_init_setsDelegateOfFetchedResultsController() {
        XCTAssertTrue(sut === fetchedResultsController.delegate)
    }
    
    func test_init_callsPerformFetch() {
        XCTAssertTrue(fetchedResultsController.performFetchCalled)
    }
    
    func test_numberOfItems_isNumberOfPosts_1() {
        fetchedResultsController.storedSections = [SectionInfo(numberOfObjects: 1)]
        
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 1)
    }
    
    func test_numberOfItems_isNumberOfPosts_2() {
        fetchedResultsController.storedSections = [SectionInfo(numberOfObjects: 2)]
        
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 2)
    }
    
    func test_cellForItemAtIndexPath_callsConfigure_onCell() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        fetchedResultsController.storedPost = post
        fetchedResultsController.storedSections = [SectionInfo(numberOfObjects: 1)]
        collectionView.register(PostCellMock.self, forCellWithReuseIdentifier: "PostCell")
        
        let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        guard let mockCell = cell as? PostCellMock else { return XCTFail() }
        XCTAssertEqual(mockCell.postToConfigureFor, post)
    }
}

extension CollectionViewDataSourceTests {
    class CollectionViewDataSourceDelegateMock: CollectionViewDataSourceDelegate {
        func configure(_ cell: UICollectionViewCell, for object: Post) {
            
        }
    }
    
    class SectionInfo: NSObject, NSFetchedResultsSectionInfo {
        var numberOfObjects: Int = 0
        var objects: [Any]?
        var name: String = ""
        var indexTitle: String?
        
        init(numberOfObjects: Int) {
            self.numberOfObjects = numberOfObjects
        }
    }
    
    class FetchedResultsControllerMock: NSFetchedResultsController<Post> {
        
        var performFetchCalled = false
        var storedSections: [SectionInfo]?
        var storedPost: Post?
        
        override var sections: [NSFetchedResultsSectionInfo]? {
            return storedSections
        }

        override func performFetch() throws {
            performFetchCalled = true
        }
        
        override func object(at indexPath: IndexPath) -> Post {
            return storedPost!
        }
    }
    
    class PostCellMock: PostCell {
        
        var postToConfigureFor: Post?
        
        override func configure(with post: Post) {
            postToConfigureFor = post
        }
    }
}
