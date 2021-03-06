//  Created by dasdom on 09/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class TextSettingsCell: UITableViewCell {
   
    let titleLabel: UILabel
    let valueLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleLabel = UILabel()
        
        valueLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
