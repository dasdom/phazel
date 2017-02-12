//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

public protocol APIClientProtocol {
    func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ())
}

final public class APIClient: APIClientProtocol {
    let keychainManager: KeychainManagerProtocol
    
    public init(keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.keychainManager = keychainManager
    }
    
    public func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        
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
    
    func posts(before: Int?, since: Int?, completion: @escaping (Result<[Post]>) -> ()) {
        
        guard let url = URLCreator.posts(before: before, since: since).url() else { fatalError() }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, error in
            
            let posts = self.extractPosts(from: data)
            let result = Result(value: posts, error: error)
            completion(result)
        }
        dataTask.resume()
    }
}

extension APIClient {
    fileprivate func extractToken(from data: Data?) -> String? {
        guard let jsonDict = jsonDict(from: data),
            let rawToken = jsonDict[JSONKey.access_token.rawValue]
            else { return nil }
        return rawToken as? String
    }
    
    fileprivate func extractLoginUser(from data: Data?) -> LoginUser? {
        guard let jsonDict = jsonDict(from: data),
            let username = jsonDict[JSONKey.username.rawValue] as? String,
            let userId = jsonDict[JSONKey.user_id.rawValue] as? Int
            else { return nil }
        return LoginUser(id: userId, username: username)
    }
    
    fileprivate func extractPosts(from data: Data?) -> [Post]? {
        guard let jsonDict = jsonDict(from: data) else { return nil }
        guard let allRawPosts = jsonDict[JSONKey.data.rawValue] as? [[String:Any]] else { return nil }
        
        var posts: [Post] = []
        for rawPost in allRawPosts {
            posts.append(Post(with: rawPost))
        }
        return posts
    }
    
    private func jsonDict(from data: Data?) -> [String:Any]? {
        guard let data = data else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        return json as? [String:Any]
    }
    
    private func jsonArray(from data: Data?) -> [Any]? {
        guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        return json as? [Any]
    }
}

enum JSONKey: String {
    case access_token, username, user_id, data
}
