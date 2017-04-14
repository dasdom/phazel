//
//  MIT License
//
//  Copyright (c) 2017 Niels van Hoorn
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Link: https://github.com/nvh/Coordinating-presentation/blob/master/SwiftConf%20XCode.playground/Contents.swift
//
//  Modified by dasdom on 11/04/2017.

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
