//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

class PostViewController: UIViewController {

    let contentView: PostViewProtocol
    let apiClient: APIClientProtocol
    
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
