//  Created by dasdom on 01/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct User: DictionaryCreatable {
    
    let name: String
    let followsYou: Bool
    let youFollow: Bool
    
    init?(with dict: [String : Any]) {
        
        name = dict["name"] as? String ?? ""
        followsYou = dict["follows_you"] as? Bool ?? false
        youFollow = dict["you_follow"] as? Bool ?? false
    }
}
