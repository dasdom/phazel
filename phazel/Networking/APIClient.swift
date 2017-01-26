//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct APIClient {
    let keychainManager: KeychainManagerProtocol
    
    func login(username: String, password: String, completion: @escaping (Bool) -> ()) {
        guard let url = URLCreator.auth(username: username, password: password).url() else { fatalError() }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            defer {
                completion(success)
            }
            
            var success = false
            guard let data = data else { return }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            guard let jsonDict = json as? [String:Any] else { return }
            guard let rawToken = jsonDict[JSONKey.access_token.rawValue] else { return }
            guard let token = rawToken as? String else { return }
            
            self.keychainManager.set(token: token, for: username)
            success = true
        }
        dataTask.resume()
    }
}

enum JSONKey: String {
    case access_token, username
}
