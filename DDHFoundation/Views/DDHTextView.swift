//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

public class DDHTextView: UITextView {

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = AppColors.text
    }
    
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }

    public func makeScrollFastOn(backgroundColor color: UIColor) {
        for subview in subviews {
            subview.backgroundColor = color
        }
    }
}
