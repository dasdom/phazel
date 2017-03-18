//  Created by dasdom on 28/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

public class DDHTextField: UITextField {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = AppColors.textFieldBackground
//        layer.borderColor = UIColor.textFieldsBorderColor.cgColor
//        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 0)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 0)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 0)
    }
}
