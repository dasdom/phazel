//  Created by dasdom on 17/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

final class PostCoordinator: CoodinatorProtocol {
    
    fileprivate let window: UIWindow
    fileprivate let apiClient: APIClientProtocol
    var childCoordinators: [CoodinatorProtocol] = []
    var childViewControllers: [UIViewController] = []

    init(window: UIWindow, apiClient: APIClientProtocol = APIClient()) {
        self.window = window
        self.apiClient = apiClient
    }
    
    func start() {
        let postViewController = PostViewController(contentView: PostView())
        postViewController.delegate = self
        childViewControllers.append(postViewController)
        
        let navigationController = UINavigationController(rootViewController: postViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = UIColor.background
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        window.rootViewController = navigationController
    }
}

extension PostCoordinator: PostViewControllerDelegate {
    
    func viewDidAppear(viewController: PostViewController) {
        if !apiClient.isLoggedIn() {
            let loginCoordinator = LoginCoordinator(window: window)
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
}

extension PostCoordinator: LoginCoordinatorDelegate {
    func coordinatorDidLogin(coordinator: LoginCoordinator, with loginUser: LoginUser) {
        guard let index = childCoordinators.index(where: { $0 as AnyObject === coordinator as AnyObject }) else {
            return
        }
        childCoordinators.remove(at: index)
    }
}
