//  Created by dasdom on 21/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct Meta {
    let code: Int
    let errorMessage: String?
}

extension Meta: DictionaryCreatable {
    init(with dictionary: [String : Any]) {
        if let tempCode = dictionary["code"] as? Int {
            code = tempCode
        } else {
            code = 0
        }
        errorMessage = dictionary["error_message"] as? String
    }
}
