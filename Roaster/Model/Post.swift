//  Created by dasdom on 06/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct Post: DictionaryCreatable {
    
    let text: String
    let id: String
    
    init?(with dict: [String : Any]) {
        
        guard let content = dict["content"] as? [String:Any] else {
            return nil
        }
        guard let unwrappedText = content["text"] as? String else {
            return nil
        }
        guard let unwrappedId = dict["id"] as? String else {
            return nil
        }
        
        text = unwrappedText
        id = unwrappedId
    }
}
