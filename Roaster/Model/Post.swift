//  Created by dasdom on 06/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct Post: DictionaryCreatable {
    
    let text: String
    
    init?(with dict: [String : Any]) {
        
        guard let content = dict["content"] as? [String:Any],
              let theText = content["text"] as? String else {
            
                return nil
        }
        text = theText
    }
}
