//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import CoreData

protocol CollectionViewDataSourceDelegate {
    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UICollectionViewCell
    func configure(_ cell: Cell, for object: Object)
}

class CollectionViewDataSource<Delegate: CollectionViewDataSourceDelegate>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    init(collectionView: UICollectionView, fetchedResultsController: NSFetchedResultsController<Post>, delegate: Delegate?) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
