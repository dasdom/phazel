//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

class APIClient {
    lazy var keychainManager: KeychainManagerProtocol = KeychainManager()
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    init() {
        
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> ()) {
        guard let url = URLCreator.auth(username: username, password: password).url() else { fatalError() }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            defer {
                completion(success)
            }
            
            var success = false
            guard let token = self.extractToken(from: data) else { return }
            
            self.keychainManager.set(token: token, for: username)
            success = true
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
}

enum JSONKey: String {
    case access_token, username
}
