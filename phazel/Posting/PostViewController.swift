//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

protocol PostViewControllerDelegate {
    func postDidSucceed(viewController: PostViewController, with postId: String)
    func postDidFail(viewController: PostViewController, with error: Error)
}

class PostViewController: UIViewController {

    let contentView: PostViewProtocol
    let apiClient: APIClientProtocol
    var delegate: PostViewControllerDelegate?
    
    init(contentView: PostViewProtocol, apiClient: APIClientProtocol = APIClient()) {
        
        self.contentView = contentView
        self.apiClient = apiClient
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        guard let contentView = self.contentView as? UIView else { fatalError() }
        view = contentView
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
