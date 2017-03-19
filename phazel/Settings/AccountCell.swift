//  Created by dasdom on 19/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation

class AccountCell: UITableViewCell {

    let titleLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleLabel = DDHLabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
