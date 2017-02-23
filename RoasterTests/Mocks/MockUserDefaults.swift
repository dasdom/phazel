//  Created by dasdom on 14/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class MockUserDefaults: UserDefaults {
    
    var string: String?
    
    init(string: String? = nil) {
        self.string = string
        
        super.init(suiteName: nil)!
    }
    
    override func string(forKey defaultName: String) -> String? {
        return string
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        if let stringValue = value as? String {
            string = stringValue
        }
    }
}
