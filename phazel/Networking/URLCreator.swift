//
//  URLCreator.swift
//  phazel
//
//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

enum URLCreator {
    case auth(username: String, password: String)
    
    func url() -> URL? {
        switch self {
        case .auth(let username, let password):
            guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted), let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted) else { fatalError() }
            let urlString = "\(self.baseURLString)oauth/access_token?username=\(encodedUsername)&password=\(encodedPassword)"
            print(urlString)
            return URL(string: urlString)
        }
    }
    
    var baseURLString: String {
        return "https://api.pnut.io/v0/"
    }
}
