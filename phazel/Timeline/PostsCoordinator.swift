//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster
import DDHFoundation

final class PostsCoordinator: NSObject, NavigationCoordinating {
    
    let rootViewController: UINavigationController
    var viewController: PostsViewController?
    fileprivate var dataSource: TableViewDataSource<PostsCoordinator>?
    fileprivate let apiClient: APIClientProtocol
    fileprivate let userDefaults: UserDefaults
//    fileprivate var childViewControllers: [UIViewController] = []
    var settingsCoordinator: SettingsCoordinator?
    var loginCoordinator: LoginCoordinator?
    
    init(rootViewController: UINavigationController, apiClient: APIClientProtocol, userDefaults: UserDefaults) {
        self.rootViewController = rootViewController
        self.apiClient = apiClient
        self.userDefaults = userDefaults
    }
    
    func createViewController() -> PostsViewController {
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//        layout.minimumLineSpacing = 1
        let postsViewController = PostsViewController(apiClient: apiClient)
        return postsViewController
    }
    
    func config(_ viewController: PostsViewController) {
        viewController.delegate = self
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        
        guard let tableView = viewController.tableView else { fatalError() }
//        tableView.rowHeight = 100
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 100
        
        dataSource = TableViewDataSource(tableView: tableView, delegate: self)
//        dataSource = CollectionViewDataSource(collectionView: collectionView, fetchedResultsController: fetchRequestController, delegate: self)
        viewController.dataSource = dataSource
    }
    
    func compose() {
        showPosting()
    }
    
    func showPosting(replyTo post: Post? = nil) {
        let postingViewController = PostingViewController(contentView: PostingView(), replyTo: post)
        postingViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: postingViewController)
        
        viewController?.present(navigationController, animated: true, completion: nil)
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
extension PostsCoordinator: PostsViewControllerDelegate {
    
    func viewDidAppear(viewController: UIViewController) {
        if !apiClient.isLoggedIn() {
            loginCoordinator = LoginCoordinator(rootViewController: viewController, apiClient: apiClient)
            loginCoordinator?.delegate = self
            loginCoordinator?.start()
        }
    }
    
    func reply(to post: Post) {
        showPosting(replyTo: post)
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

extension PostsCoordinator: TableViewDataSourceDelegate {
    func configure(_ cell: PostCell, for object: Post) {
        cell.configure(with: object)
    }
}
