//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

enum URLCreator {
    case auth(username: String, password: String)
    
    func url() -> URL? {
        switch self {
        case .auth(let username, let password):
            var queryItems = [URLQueryItem(name: "username", value: username),
                              URLQueryItem(name: "password", value: password),
                              URLQueryItem(name: "grant_type", value: "password"),
                              URLQueryItem(name: "scope", value: "stream,write_post,follow,update_profile,presence,messages")]
            
            if let secretsDict = secretsDict {
                for (key, value) in secretsDict {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
            }
            
            let urlComponents = URLComponents(queryItems: queryItems)
            return urlComponents.url
        }
    }
}

extension URLCreator {
    fileprivate var secretsDict: [String:String]? {
        guard let secretURL = Bundle.main.url(forResource: "secrets", withExtension: "json") else { fatalError() }
        guard let secretData = try? Data(contentsOf: secretURL) else { fatalError() }
        let secretsDict = try? JSONSerialization.jsonObject(with: secretData, options: [])
        return secretsDict as? [String:String]
    }
    
    fileprivate var queryItemAllowedCharacterSet: CharacterSet {
        return CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
    }
}

extension URLComponents {
    init(queryItems: [URLQueryItem]) {
        self.init()
        scheme = "https"
        host = "api.pnut.io"
        path = "/v0/oauth/access_token"
        self.queryItems = queryItems
    }
}
