//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

enum URLCreator {
    case auth(username: String, password: String)
    case posts(before: Int?, since: Int?)
    
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
            
            let urlComponents = URLComponents(path: "/v0/oauth/access_token", queryItems: queryItems)
            return urlComponents.url
        case .posts(let before, let since):
            var queryItems: [URLQueryItem] = []
            
            if let before = before {
                queryItems.append(URLQueryItem(name: "before_id", value: "\(before)"))
            } else if let since = since {
                queryItems.append(URLQueryItem(name: "since_id", value: "\(since)"))
                queryItems.append(URLQueryItem(name: "count", value: "200"))
            }
            
            let urlComponents = URLComponents(path: "/v0/posts/streams/unified", queryItems: queryItems)
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
    init(path: String, queryItems: [URLQueryItem]) {
        self.init()
        scheme = "https"
        host = "api.pnut.io"
        self.path = path
        self.queryItems = queryItems
    }
}
