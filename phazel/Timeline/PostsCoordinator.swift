//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster
import DDHFoundation
import CoreData

final class PostsCoordinator: NavigationCoordinating {
    
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
    
//    func start() {
//        let postsViewController = PostsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), dataSource: CollectionViewDataSource(), backgroundContext: persistentContainer.newBackgroundContext(), apiClient: apiClient)//PostViewController(contentView: PostView(), apiClient: apiClient)
//        postsViewController.delegate = self
//        childViewControllers.append(postsViewController)
//        
//        let navigationController = UINavigationController(rootViewController: postsViewController)
//        navigationController.navigationBar.isTranslucent = false
//        navigationController.navigationBar.barTintColor = AppColors.bar
//        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppColors.barText]
//        window.rootViewController = navigationController
//    }
    
    func createViewController() -> PostsCollectionViewController {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.minimumLineSpacing = 1
        let postsViewController = PostsCollectionViewController(collectionViewLayout: layout, backgroundContext: persistentContainer.newBackgroundContext(), apiClient: apiClient)
        return postsViewController
    }
    
    func config(_ viewController: PostsCollectionViewController) {
        viewController.delegate = self
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
        
        guard let collectionView = viewController.collectionView else { fatalError() }
        let fetchRequestController = NSFetchedResultsController(fetchRequest: Post.sortedFetchRequest(), managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = CollectionViewDataSource(collectionView: collectionView, fetchedResultsController: fetchRequestController, delegate: self)
        viewController.dataSource = dataSource
    }
}

// MARK: - PostsCollectionViewControllerDelegate
extension PostsCoordinator: PostsCollectionViewControllerDelegate {
    
}

// MARK: - PostViewControllerDelegate
extension PostsCoordinator: PostViewControllerDelegate {
    
    func viewDidAppear(viewController: UIViewController) {
        if !apiClient.isLoggedIn() {
            loginCoordinator = LoginCoordinator(rootViewController: viewController, apiClient: apiClient)
            loginCoordinator?.delegate = self
            loginCoordinator?.start()
        }
    }
    
    func postDidSucceed(viewController: PostViewController, with postId: String) {
        
    }
    
    func postDidFail(viewController: PostViewController, with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showInfo(viewController: PostViewController) {
        let navigationController = UINavigationController()
        viewController.present(navigationController, animated: true, completion: nil)
        
        settingsCoordinator = SettingsCoordinator(rootViewController: navigationController, userDefaults: UserDefaults())
        settingsCoordinator?.delegate = self
        settingsCoordinator?.start()
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
