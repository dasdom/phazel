//  Created by dasdom on 23.11.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class MentionsCoordinator: PostsCoordinator {

    override func createViewController() -> MentionsViewController {
        let user = User(dict: ["id": "me"])
        let mentionsViewController = MentionsViewController(user: user, apiClient: apiClient)
        mentionsViewController.title = "Mentions"
        return mentionsViewController
    }
}
