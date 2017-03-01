//  Created by Dominik Hauser on 01/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct Source: DictionaryCreatable {
    
    let name: String
    
    init?(with dict:[String : Any]) {
        
        if let unwrappedName = dict["name"] as? String {
            name = unwrappedName
        } else {
            name = ""
        }
    }
}
