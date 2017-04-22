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
    var dataSource: CollectionViewDataSource<PostsCoordinator>?

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
        
        collectionView?.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
        
        let post = dataSource?.object(at: IndexPath(item: 0, section: 0))
        var sinceId: Int? = nil
        if let sinceIdString = post?.id {
            sinceId = Int(sinceIdString)
        }
        print(">>> sinceId: \(String(describing: sinceId))")
        
        self.apiClient.posts(before: nil, since: sinceId) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            if case .success(let dataArray) = result {
                for dict in dataArray {
                    _ = Post(dict: dict, context: strongSelf.backgroundContext)
                }
                
                let fetchRequest = Post.sortedFetchRequest(batchSize: 0)
                strongSelf.backgroundContext.perform {
                    do {
                        let posts = try fetchRequest.execute()
                        for post in posts.dropFirst(1000) {
                            self?.backgroundContext.delete(post)
                        }
                        try! self?.backgroundContext.save()
                    } catch {
                        print(error)
                        try! self?.backgroundContext.save()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate?.viewDidAppear(viewController: self)
    }

}
