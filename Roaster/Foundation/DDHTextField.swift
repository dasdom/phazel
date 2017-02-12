//  Created by dasdom on 28/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

public class DDHTextField: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
