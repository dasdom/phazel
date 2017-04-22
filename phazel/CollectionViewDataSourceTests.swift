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
    var delegate: CollectionViewDataSourceDelegateMock!
    
    override func setUp() {
        super.setUp()

        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, _ in }
        
        container?.viewContext.automaticallyMergesChangesFromParent = true

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
        fetchedResultsController = FetchedResultsControllerMock(fetchRequest: Post.sortedFetchRequest(), managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        delegate = CollectionViewDataSourceDelegateMock()
        sut = CollectionViewDataSource(collectionView: collectionView, fetchedResultsController: fetchedResultsController, delegate: delegate)
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
    
    func test_cellForItemAtIndexPath_callsConfigure_onDelegate() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        fetchedResultsController.storedPost = post
        fetchedResultsController.storedSections = [SectionInfo(numberOfObjects: 1)]
        collectionView.register(PostCellMock.self, forCellWithReuseIdentifier: "Cell")
        
        _ = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(delegate.post, post)
        XCTAssertNotNil(delegate.cell)
    }
    
    func test_controllerWillChangeContent_removesBlockOperations() {
        let operations = BlockOperation {}
        sut.blockOperations = [operations]
        
        sut.controllerWillChangeContent(sut.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        XCTAssertEqual(sut.blockOperations.count, 0)
    }
    
    func test_controllerDidInsertObject_insertsItem() {
        let collectionViewMock = CollectionViewMock(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
        sut = CollectionViewDataSource(collectionView: collectionViewMock, fetchedResultsController: fetchedResultsController, delegate: CollectionViewDataSourceDelegateMock())

        sut.controller(sut.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: "Foo", at: nil, for: .insert, newIndexPath: IndexPath(item: 0, section: 0))
        
        guard let operation = sut.blockOperations.first else { return XCTFail() }
        operation.start()
        XCTAssertEqual(collectionViewMock.insertedIndexPaths.count, 1)
        XCTAssertEqual(collectionViewMock.deletedIndexPaths.count, 0)
    }
    
    func test_controllerDidDeleteObject_deletesItem() {
        let collectionViewMock = CollectionViewMock(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
        sut = CollectionViewDataSource(collectionView: collectionViewMock, fetchedResultsController: fetchedResultsController, delegate: CollectionViewDataSourceDelegateMock())
        
        sut.controller(sut.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, didChange: "Foo", at: IndexPath(item: 0, section: 0), for: .delete, newIndexPath: nil)
        
        guard let operation = sut.blockOperations.first else { return XCTFail() }
        operation.start()
        XCTAssertEqual(collectionViewMock.insertedIndexPaths.count, 0)
        XCTAssertEqual(collectionViewMock.deletedIndexPaths.count, 1)
    }
    
    func test_controllerDidChangeContent_startsOperations() {
        let collectionViewMock = CollectionViewMock(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
        sut = CollectionViewDataSource(collectionView: collectionViewMock, fetchedResultsController: fetchedResultsController, delegate: CollectionViewDataSourceDelegateMock())
        var catchedString: String?
        let operation = BlockOperation { catchedString = "Foo" }
        sut.blockOperations = [operation]
        XCTAssertNil(catchedString)
        
        sut.controllerDidChangeContent(sut.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        collectionViewMock.updates?()
        collectionViewMock.completion?(true)
        
        XCTAssertEqual(catchedString, "Foo")
        XCTAssertEqual(sut.blockOperations.count, 0)
    }
    
    func test_objectAt_returnsObjectFromFetchedResultsController() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict, context: container.viewContext)
        fetchedResultsController.storedPost = post
        
        let catchedPost = sut.object(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(catchedPost, post)
    }
}

extension CollectionViewDataSourceTests {
    class CollectionViewDataSourceDelegateMock: CollectionViewDataSourceDelegate {
        
        var cell: UICollectionViewCell?
        var post: Post?
        
        func configure(_ cell: UICollectionViewCell, for object: Post) {
            self.cell = cell
            self.post = object
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
        
        override var fetchedObjects: [Post]? {
            return [storedPost!]
        }
    }
    
    class PostCellMock: PostCell {
        
        var postToConfigureFor: Post?
        
        override func configure(with post: Post) {
            postToConfigureFor = post
        }
    }
    
    class CollectionViewMock: UICollectionView {
        
        var insertedIndexPaths: [IndexPath] = []
        var deletedIndexPaths: [IndexPath] = []
        
        typealias Update = () -> Void
        typealias Completion = (Bool) -> Void
        
        var updates: Update?
        var completion: Completion?
        
        override func insertItems(at indexPaths: [IndexPath]) {
            insertedIndexPaths = indexPaths
        }
        
        override func deleteItems(at indexPaths: [IndexPath]) {
            deletedIndexPaths = indexPaths
        }
        
        override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
            
            self.updates = updates
            self.completion = completion
        }
    }
}
