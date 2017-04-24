//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster
import DDHFoundation
import CoreData

final class PostsCoordinator: NSObject, NavigationCoordinating {
    
    let rootViewController: UINavigationController
    var viewController: PostsCollectionViewController?
    fileprivate var dataSource: CollectionViewDataSource<PostsCoordinator>?
    fileprivate let apiClient: APIClientProtocol
    fileprivate let userDefaults: UserDefaults
//    fileprivate var childViewControllers: [UIViewController] = []
    fileprivate let persistentContainer: NSPersistentContainer
    var settingsCoordinator: SettingsCoordinator?
    var loginCoordinator: LoginCoordinator?
    
    init(rootViewController: UINavigationController, apiClient: APIClientProtocol, userDefaults: UserDefaults, persistentContainer: NSPersistentContainer) {
        self.rootViewController = rootViewController
        self.apiClient = apiClient
        self.userDefaults = userDefaults
        self.persistentContainer = persistentContainer
        
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func createViewController() -> PostsCollectionViewController {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.minimumLineSpacing = 1
        let postsViewController = PostsCollectionViewController(collectionViewLayout: layout, backgroundContext: persistentContainer.newBackgroundContext(), apiClient: apiClient)
        return postsViewController
    }
    
    func config(_ viewController: PostsCollectionViewController) {
        viewController.delegate = self
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showPosting))
        
        guard let collectionView = viewController.collectionView else { fatalError() }
        let fetchRequestController = NSFetchedResultsController(fetchRequest: Post.sortedFetchRequest(), managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = CollectionViewDataSource(collectionView: collectionView, fetchedResultsController: fetchRequestController, delegate: self)
        viewController.dataSource = dataSource
    }
    
    func showPosting() {
        let postingViewController = PostingViewController(contentView: PostingView())
        postingViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: postingViewController)
        
        viewController?.present(navigationController, animated: false, completion: nil)
    }
    
    func showInfo() {
        let navigationController = UINavigationController()
        viewController?.present(navigationController, animated: true, completion: nil)
        
        settingsCoordinator = SettingsCoordinator(rootViewController: navigationController, userDefaults: UserDefaults())
        settingsCoordinator?.delegate = self
        settingsCoordinator?.start()
    }
}

// MARK: - PostingViewControllerDelegate
extension PostsCoordinator: PostingViewControllerDelegate {
    func send(text: String, replyTo: String?) {
        
        dismiss()
        
        apiClient.post(text: text, replyTo: replyTo) { result in
            switch result {
            case .success(let postId):
                print("success posting: \(postId)")
            case .failure(let error):
                let alertController = UIAlertController(title: "Posting error", message: error.localizedDescription, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                alertController.addAction(UIAlertAction(title: "Try again", style: .default, handler: { action in
                    self.send(text: text, replyTo: replyTo)
                }))
                    
                self.viewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - PostsCollectionViewControllerDelegate
extension PostsCoordinator: PostsCollectionViewControllerDelegate {
    
    func viewDidAppear(viewController: UIViewController) {
        if !apiClient.isLoggedIn() {
            loginCoordinator = LoginCoordinator(rootViewController: viewController, apiClient: apiClient)
            loginCoordinator?.delegate = self
            loginCoordinator?.start()
        }
    }
    
    func postDidSucceed(viewController: PostingViewController, with postId: String) {
    }
    
    func postDidFail(viewController: PostingViewController, with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - LoginCoordinatorDelegate
extension PostsCoordinator: LoginCoordinatorDelegate {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
        coordinator.stop()
    }
}

// MARK: - SettingsCoordinatorDelegate
extension PostsCoordinator: SettingsCoordinatorDelegate {
    func settingsDidFinish(coordinator: SettingsCoordinator) {
//        guard let index = childCoordinators.index(where: { $0 as AnyObject === coordinator as AnyObject }) else {
//            return
//        }
//        childCoordinators.remove(at: index)
    }
}

extension PostsCoordinator: CollectionViewDataSourceDelegate {
    func configure(_ cell: PostCell, for object: Post) {
        cell.configure(with: object)
    }
}
