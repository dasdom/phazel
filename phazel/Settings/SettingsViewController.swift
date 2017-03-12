//  Created by dasdom on 04/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    let settingsItems: [SettingsItem]
    let textCellIdentifier = "textCellIdentifier"
    
    init(settingsItems: [SettingsItem]) {
        
        self.settingsItems = settingsItems
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TextSettingsCell.self, forCellReuseIdentifier: textCellIdentifier)
    }
    
    func item(for indexPath: IndexPath) -> SettingsItem? {
        return settingsItems[indexPath.row]
    }
    
    func cell(forItemAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! TextSettingsCell
        if let item = item(for: indexPath) {
            if case .string(let title, _) = item {
                cell.titleLabel.text = title
            }
        }
        return cell
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellToReturn = cell(forItemAt: indexPath)
        return cellToReturn
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(rowAt: indexPath)
    }
}

// MARK: Delegate protocol
protocol SettingsViewControllerDelegate: class {
    func didSetSettingsFor<T>(key: String, withValue: T?)
    func didSelect(rowAt: IndexPath)
}

