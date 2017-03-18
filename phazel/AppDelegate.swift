//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var mainCoordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let window = window else { fatalError() }
        window.tintColor = AppColors.tint
        mainCoordinator = MainCoordinator(window: window)
        mainCoordinator?.start()
        
//        application.statusBarStyle = .lightContent
        
        return true
    }
    
}

