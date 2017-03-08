//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var settingsItems: [SettingsItem] = [SettingsItem(title: "Active Account")]
}

protocol SettingsViewControllerDelegate: class {
    func didSetSettingsFor<T>(key: String, withValue: T?)
}

