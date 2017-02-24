//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol PostViewControllerDelegate: class {
    func viewDidAppear(viewController: PostViewController)
    func postDidSucceed(viewController: PostViewController, with postId: String)
    func postDidFail(viewController: PostViewController, with error: Error)
}

class PostViewController: UIViewController {

    let contentView: PostViewProtocol
    let apiClient: APIClientProtocol
    weak var delegate: PostViewControllerDelegate?
    fileprivate var bottomConstraint: NSLayoutConstraint?
    
    init(contentView: PostViewProtocol, apiClient: APIClientProtocol = APIClient()) {
        
        self.contentView = contentView
        self.apiClient = apiClient
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func loadView() {
        guard let contentView = self.contentView as? UIView else { fatalError() }
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        title = "Create a nut"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate?.viewDidAppear(viewController: self)
        
        contentView.setFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.topView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        bottomConstraint = contentView.topView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10)
        bottomConstraint?.isActive = true
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        guard let frame = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let convertedFrame = view.convert(frame, from: nil)
        
        bottomConstraint?.constant = -convertedFrame.height - 10
        self.view.layoutIfNeeded()
    }
}

extension PostViewController: PostProtocol {
    func send() {
        guard let text = contentView.text else { return }
        apiClient.post(text: text) { result in
            
            switch result {
            case .success(let postId):
                self.contentView.reset()
                self.delegate?.postDidSucceed(viewController: self, with: postId)
            case .failure(let error):
                self.delegate?.postDidFail(viewController: self, with: error)
            }
        }
    }
}

fileprivate extension Selector {
    static let keyboardWillShow = #selector(PostViewController.keyboardWillShow(sender:))
}

