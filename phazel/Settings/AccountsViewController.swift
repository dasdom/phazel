//  Created by dasdom on 12/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Roaster

class AccountsViewController: UITableViewController {

    let accounts: [LoginUser]
    let accountCellIdentifier = String(describing: AccountCell.self)

    init(accounts: [LoginUser]) {
        
        self.accounts = accounts
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AccountCell.self, forCellReuseIdentifier: accountCellIdentifier)
    }
}

// MARK: - UITableViewDataSource
extension AccountsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: accountCellIdentifier, for: indexPath) as! AccountCell
        let item = accounts[indexPath.row]
        cell.titleLabel.text = item.username
        return cell
    }
}