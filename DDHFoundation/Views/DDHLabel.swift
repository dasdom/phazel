//  Created by dasdom on 23/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

public class DDHLabel: UILabel {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = UIColor.yellow
    }
    
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    public func makeScrollFastOn(backgroundColor color: UIColor) {
        isOpaque = true
        backgroundColor = color
    }
}
