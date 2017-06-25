//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol PostingViewControllerDelegate: class {
////    func viewDidAppear(viewController: PostingViewController)
//    func postsDidSucceed(viewController: PostingViewController, with postId: String)
//    func postsDidFail(viewController: PostingViewController, with error: Error)
//    func showInfo(viewController: PostingViewController)
    func send(text: String, replyTo: String?)
}

class PostingViewController: UIViewController {

    var contentView: PostingViewProtocol
//    let apiClient: APIClientProtocol
    weak var delegate: PostingViewControllerDelegate?
    fileprivate var bottomConstraint: NSLayoutConstraint?
    var postToReplyTo: Post?
    
    init(contentView: PostingViewProtocol, replyTo: Post? = nil) {
        
        self.contentView = contentView
        if let username = replyTo?.user?.username {
            self.contentView.text = "@\(username) "
        }
//        self.apiClient = apiClient
        postToReplyTo = replyTo
        
        super.init(nibName: nil, bundle: nil)

        edgesForExtendedLayout = []
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
        
//        self.delegate?.viewDidAppear(viewController: self)
        
        contentView.setFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.topView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        bottomConstraint = contentView.topView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10)
//        bottomConstraint?.priority = 999
        bottomConstraint?.isActive = true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        guard let frame = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let convertedFrame = view.convert(frame, from: nil)
        
        bottomConstraint?.constant = -convertedFrame.height - 10
        self.view.layoutIfNeeded()
    }
}

extension PostingViewController: PostProtocol {
    func send() {
        guard let text = contentView.text else { return }
        contentView.set(animating: true)
        delegate?.send(text: text, replyTo: postToReplyTo?.id)
    }
}

fileprivate extension Selector {
    static let keyboardWillShow = #selector(PostingViewController.keyboardWillShow(sender:))
}

