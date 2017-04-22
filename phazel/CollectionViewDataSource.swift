//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
//import Foundation
import CoreData

protocol CollectionViewDataSourceDelegate {
    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UICollectionViewCell
    func configure(_ cell: Cell, for object: Object)
}

protocol CollectionViewDataSourceProtocol {
    associatedtype Object: NSFetchRequestResult
    func object(at indexPath: IndexPath) -> Object
}

class CollectionViewDataSource<Delegate: CollectionViewDataSourceDelegate>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    let collectionView: UICollectionView
    let fetchedResultsController: NSFetchedResultsController<Object>
    let delegate: Delegate?
    var blockOperations: [BlockOperation] = []

    init(collectionView: UICollectionView, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate?) {
        
        self.collectionView = collectionView
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        
        super.init()
        
        self.fetchedResultsController.delegate = self
        try! self.fetchedResultsController.performFetch()
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        let post = fetchedResultsController.object(at: indexPath)
        delegate?.configure(cell, for: post)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let fetchRequest: NSFetchRequest<Object> = fetchedResultsController.fetchRequest
        fetchRequest.returnsObjectsAsFaults = false
        let objects = indexPaths.map({ (index) -> Object in
            self.fetchedResultsController.object(at: index)
        })
        fetchRequest.predicate = NSPredicate(format: "SELF IN %@", objects as CVarArg)
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest,
                                                           completionBlock: nil)
        do {
            try fetchedResultsController.managedObjectContext.execute(asyncFetchRequest)
        } catch {}
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("didChange")
        switch type {
        case .insert:
            blockOperations.append(BlockOperation(block: { [weak self] in
                if let strongSelf = self, let unwrappedNewIndexPath = newIndexPath {
                    strongSelf.collectionView.insertItems(at: [unwrappedNewIndexPath])
                }
            }))
        case .delete:
            blockOperations.append(BlockOperation(block: { [weak self] in
                if let strongSelf = self, let unwrappedIndexPath = indexPath {
                    strongSelf.collectionView.deleteItems(at: [unwrappedIndexPath])
                }
            }))
        default:
            fatalError("Not insert, not delete")
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        collectionView.performBatchUpdates({ () -> Void in
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
//}
//
//extension CollectionViewDataSource: CollectionViewDataSourceProtocol {
    func object(at indexPath: IndexPath) -> Object? {
        return fetchedResultsController.fetchedObjects?.count ?? -1 > 0 ? fetchedResultsController.object(at: indexPath) : nil
    }
}
