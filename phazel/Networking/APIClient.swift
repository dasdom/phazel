//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

class APIClient {
    private(set) lazy var keychainManager: KeychainManagerProtocol = KeychainManager()
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    init() {
        
    }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        guard let url = URLCreator.auth(username: username, password: password).url() else { fatalError() }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, error in
            
            defer {
                completion(result)
            }
            
            let loginUser = self.extractLoginUser(from: data)
            let result = Result(value: loginUser, error: error)
            guard let token = self.extractToken(from: data) else { return }
            
            self.keychainManager.set(token: token, for: username)
        }
        dataTask.resume()
    }
}

extension APIClient {
    fileprivate func extractToken(from data: Data?) -> String? {
        guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String:Any],
            let rawToken = jsonDict[JSONKey.access_token.rawValue]
            else { return nil }
        return rawToken as? String
    }
    
    fileprivate func extractLoginUser(from data: Data?) -> LoginUser? {
        guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String:Any],
            let username = jsonDict[JSONKey.username.rawValue] as? String,
            let userId = jsonDict[JSONKey.user_id.rawValue] as? Int
            else { return nil }
        return LoginUser(id: userId, username: username)
    }
}

enum JSONKey: String {
    case access_token, username, user_id
}
