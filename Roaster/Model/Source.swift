//  Created by Dominik Hauser on 01/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct Source: DictionaryCreatable {
    
    let name: String
    let url: URL
    
    init?(with dict:[String : Any]) {
        
        if let unwrappedName = dict["name"] as? String {
            name = unwrappedName
        } else {
            name = ""
        }
        
        if let urlString = dict["link"] as? String, let unwrappedURL = URL(string: urlString) {
            url = unwrappedURL
        } else {
            url = URL(string: "NoLink")!
        }
    }
}
