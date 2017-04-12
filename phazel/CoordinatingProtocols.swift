//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

protocol Coordinating: class {
    associatedtype RootViewController: UIViewController
    associatedtype ViewController: UIViewController
    
    var rootViewController: RootViewController { get }
    var viewController: ViewController? { get set }
    
    func createViewController() -> ViewController
    func config(_ viewController: ViewController)
    func show(_ viewController: ViewController)
    func dismiss()
}

extension Coordinating {
    func start() {
        let vC = createViewController()
        self.viewController = vC
        config(vC)
        show(vC)
    }
    func stop() {
        dismiss()
        viewController = nil
    }
}

extension Coordinating {
    func config(_ viewController: Self.ViewController) {
    }
    
    func show(_ viewController: Self.ViewController) {
        rootViewController.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

protocol NavigationCoordinating: Coordinating {
    typealias RootViewController = UINavigationController
}

extension NavigationCoordinating {
    func show(_ viewController: Self.ViewController) {
        rootViewController.pushViewController(viewController, animated: true)
    }
}
