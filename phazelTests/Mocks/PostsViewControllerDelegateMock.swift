//  Created by dasdom on 22.10.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
@testable import phazel

class PostsViewControllerDelegateMock: PostsViewControllerDelegate {
    
    var lastRepliedPost: Post?
    var lastShowProfilePost: Post?
    var lastShowThreadPost: Post?
    
    func viewDidAppear(viewController: UIViewController) {
        
    }
    
    func reply(_ viewController: UIViewController, to post: Post) {
        lastRepliedPost = post
    }
    
    func showProfile(_: UIViewController, for post: Post) {
        lastShowProfilePost = post
    }
    
    func showThread(_: UIViewController, for post: Post) {
        lastShowThreadPost = post
    }
    
    func viewController(_: UIViewController, tappedLink: Link) {
        
    }
    
    func viewController(_: UIViewController, tappedUser: User) {
        
    }
}
