//  Created by dasdom on 12/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class AccountsViewController: UITableViewController {

    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        
        self.userDefaults = userDefaults
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
