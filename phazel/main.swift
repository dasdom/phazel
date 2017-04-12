//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

var appDelegateClass: AnyClass? = NSClassFromString("phazelTests.TestingAppDelegate")
if appDelegateClass == nil {
  appDelegateClass = NSClassFromString("RoasterTests.TestingAppDelegate")
}
if appDelegateClass == nil {
    appDelegateClass = NSClassFromString("DDHFoundationTests.TestingAppDelegate")
}
if appDelegateClass == nil {
    appDelegateClass = AppDelegate.self
}
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(appDelegateClass!))

