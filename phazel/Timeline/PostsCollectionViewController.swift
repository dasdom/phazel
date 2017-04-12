//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import CoreData
import Roaster

protocol PostsCollectionViewControllerDelegate: class {
    func viewDidAppear(viewController: UIViewController)
}

class PostsCollectionViewController: UICollectionViewController {

    private let backgroundContext: NSManagedObjectContext
    let apiClient: APIClientProtocol
    weak var delegate: PostsCollectionViewControllerDelegate?

    init(collectionViewLayout layout: UICollectionViewLayout, backgroundContext: NSManagedObjectContext, apiClient: APIClientProtocol) {
        
        self.backgroundContext = backgroundContext
        self.apiClient = apiClient
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiClient.posts(before: nil, since: nil) { result in
            
            if case .success(let dataArray) = result {
                for dict in dataArray {
                    _ = Post(dict: dict, context: self.backgroundContext)
                }
                try! self.backgroundContext.save()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate?.viewDidAppear(viewController: self)
    }

}
