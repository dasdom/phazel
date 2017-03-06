//  Created by dasdom on 02/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

// Copied from: http://stackoverflow.com/a/35773783/498796

import UIKit

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewController(from: self.rootViewController)
    }
    
    public static func getVisibleViewController(from vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewController(from: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewController(from: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewController(from: pvc)
            } else {
                return vc
            }
        }
    }
}
