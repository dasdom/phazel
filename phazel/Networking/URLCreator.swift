//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

enum URLCreator {
    case auth(username: String, password: String)
    
    func url() -> URL? {
        switch self {
        case .auth(let username, let password):
            guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: queryItemAllowedCharacterSet),
                let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: queryItemAllowedCharacterSet) else { fatalError() }
            let urlString = "\(baseURLString)oauth/access_token?username=\(encodedUsername)&password=\(encodedPassword)"
            print(urlString)
            return URL(string: urlString)
        }
    }
    
    private var baseURLString: String {
        return "https://api.pnut.io/v0/"
    }
    
    private var queryItemAllowedCharacterSet: CharacterSet {
        return CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
    }
}
