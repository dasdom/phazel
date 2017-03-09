//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    let settingsItems: [SettingsItem]
    
    init(settingsItems: [SettingsItem]) {
        
        self.settingsItems = settingsItems
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func item(for indexPath: NSIndexPath) -> SettingsItem? {
        return SettingsItem.string("Account", "foobar")
    }
    
    func cell(forItemAt indexPath: NSIndexPath) -> UITableViewCell {
        return TextSettingsCell()
    }
}

protocol SettingsViewControllerDelegate: class {
    func didSetSettingsFor<T>(key: String, withValue: T?)
}

