//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class PostCoordinator: CoodinatorProtocol {
    
    fileprivate let window: UIWindow
    fileprivate let apiClient: APIClientProtocol
    fileprivate let userDefaults: UserDefaults
    var childCoordinators: [CoodinatorProtocol] = []
    var childViewControllers: [UIViewController] = []
    
    init(window: UIWindow, apiClient: APIClientProtocol, userDefaults: UserDefaults) {
        self.window = window
        self.apiClient = apiClient
        self.userDefaults = userDefaults
    }
    
    func start() {
        let postViewController = PostViewController(contentView: PostView(), apiClient: apiClient)
        postViewController.delegate = self
        childViewControllers.append(postViewController)
        
        let navigationController = UINavigationController(rootViewController: postViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = UIColor.background
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        window.rootViewController = navigationController
    }
}

// MARK: - PostViewControllerDelegate
extension PostCoordinator: PostViewControllerDelegate {
    
    func viewDidAppear(viewController: PostViewController) {
        if !apiClient.isLoggedIn() {
            let loginCoordinator = LoginCoordinator(window: window, apiClient: apiClient)
            loginCoordinator.delegate = self
            childCoordinators.append(loginCoordinator)
            loginCoordinator.start()
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
        let settingsCoordinator = SettingsCoordinator(window: window, userDefaults: UserDefaults())
        settingsCoordinator.delegate = self
        childCoordinators.append(settingsCoordinator)
        
        settingsCoordinator.start()
    }
}

// MARK: - LoginCoordinatorDelegate
extension PostCoordinator: LoginCoordinatorDelegate {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
        guard let index = childCoordinators.index(where: { $0 as AnyObject === coordinator as AnyObject }) else {
            return
        }
        childCoordinators.remove(at: index)
    }
}

// MARK: - SettingsCoordinatorDelegate
extension PostCoordinator: SettingsCoordinatorDelegate {
    func settingsDidFinish(coordinator: SettingsCoordinator) {
        guard let index = childCoordinators.index(where: { $0 as AnyObject === coordinator as AnyObject }) else {
            return
        }
        childCoordinators.remove(at: index)
    }
}
