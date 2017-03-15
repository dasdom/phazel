//  Created by dasdom on 28/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

open class DDHView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.background
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
