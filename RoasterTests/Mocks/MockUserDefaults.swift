//  Created by dasdom on 14/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class MockUserDefaults: UserDefaults {
    
    private var values: [String:Any] = [:]

    init(values: [String:Any] = [:]) {
        self.values = values
        
        super.init(suiteName: nil)!
    }
    
    override func string(forKey defaultName: String) -> String? {
        return values[defaultName] as? String
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        if let value = value {
            values[defaultName] = value
        }
    }
    
    override func value(forKey key: String) -> Any? {
        return values[key]
    }
}
