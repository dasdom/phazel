//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import CoreData
import Roaster

class PostsCollectionViewController: UICollectionViewController {

    private let dataSource: UICollectionViewDataSource
    private let persistentContainer: NSPersistentContainer
    let apiClient: APIClientProtocol

    init(collectionViewLayout layout: UICollectionViewLayout, dataSource: UICollectionViewDataSource, persistentContainer: NSPersistentContainer, apiClient: APIClientProtocol) {
        
        self.dataSource = dataSource
        self.persistentContainer = persistentContainer
        self.apiClient = apiClient
        
        super.init(collectionViewLayout: layout)
        
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = self.dataSource
        
        self.apiClient.posts(before: nil, since: nil) { result in
            
            if case .success(let dataArray) = result {
                self.persistentContainer.performBackgroundTask({ context in
                    for dict in dataArray {
                        _ = Post(dict: dict, context: context)
                    }
                    try! context.save()
                })
            }
        }

    }

}
