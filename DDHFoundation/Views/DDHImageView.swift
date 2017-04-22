//  Created by dasdom on 22/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

public class DDHImageView: UIImageView {
    
    public init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
//        layer.borderColor = UIColor.black.cgColor
//        layer.borderWidth = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
