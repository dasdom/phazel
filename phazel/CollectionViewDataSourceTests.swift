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

    override func setUp() {
        super.setUp()

        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, error in
            
        }

        collectionView = UICollectionView()
        let fetchedResultController = NSFetchedResultsController(fetchRequest: Post.fetchRequest(), managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        sut = CollectionViewDataSource(collectionView: UICollectionView(), fetchedResultsController: fetchedResultController, delegate: nil)
    }
    
    override func tearDown() {
        sut = nil
        container = nil
        
        super.tearDown()
    }
    
    
}

extension CollectionViewDataSourceTests {
    class CollectionViewDataSourceDelegateMock: CollectionViewDataSourceDelegate {
        func configure(_ cell: UICollectionViewCell, for object: Post) {
            
        }
    }
}
