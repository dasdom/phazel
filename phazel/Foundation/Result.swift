//  Created by dasdom on 29/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    
    init(value: T?, error: Error?) {
        switch (value, error) {
        case (let v?, _):
            // Ignore error if value is non-nil
            self = .success(v)
        case (nil, let e?):
            self = .failure(e)
        case (nil, nil):
            let error = NSError(domain: "ResultErrorDomain", code: 1,
                                userInfo: [NSLocalizedDescriptionKey:
                                    "Invalid input: value and error were both nil."])
            self = .failure(error)
        }
    }
}
