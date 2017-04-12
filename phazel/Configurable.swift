//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

protocol Configurable {
    associatedtype DataType: Any
    func config(withItem item: DataType)
}
