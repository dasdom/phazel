//  Created by dasdom on 09.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class ProfileCoordinator: PostsCoordinator {
    
    override func createViewController() -> ProfileViewController {
        let user = User(dict: ["id": "me"])
        let profileViewController = ProfileViewController(user: user, apiClient: apiClient)
        profileViewController.title = "Profile"
        return profileViewController
    }
}
