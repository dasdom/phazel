//  Created by dasdom on 09/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class TextSettingsCell: UITableViewCell {
    let titleLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
