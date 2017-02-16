//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

public protocol APIClientProtocol {
    func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ())
    func post(text: String, completion: @escaping (Result<String>) -> ())
}

final public class APIClient: APIClientProtocol {
    let keychainManager: KeychainManagerProtocol
    let userDefaults: UserDefaults
    
    public init(keychainManager: KeychainManagerProtocol = KeychainManager(), userDefaults: UserDefaults = UserDefaults.standard) {
        self.keychainManager = keychainManager
        self.userDefaults = userDefaults
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
        guard let username = currentUsername else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoUserInUserDefaults", code: 1001, userInfo: nil)))
        }
        guard let token = keychainManager.token(for: username) else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoTokenInKeychain", code: 1002, userInfo: nil)))
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in
            
            let posts = self.extractPosts(from: data)
            let result = Result(value: posts, error: error)
            completion(result)
        }
        dataTask.resume()
    }
    
    public func post(text: String, completion: @escaping (Result<String>) -> ()) {
        
        guard let url = URLCreator.post.url() else { fatalError() }
        guard let username = currentUsername else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoUserInUserDefaults", code: 1001, userInfo: nil)))
        }
        guard let token = keychainManager.token(for: username) else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoTokenInKeychain", code: 1002, userInfo: nil)))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "text=\(text)".data(using: .utf8)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in
            
            let postId = self.extractPostId(from: data)
            let result = Result(value: postId, error: error)
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
    
    fileprivate func extractPostId(from data: Data?) -> String? {
        guard let jsonDict = jsonDict(from: data) else { return nil }
        guard let rawPost = jsonDict[JSONKey.data.rawValue] as? [String:Any] else { return nil }
        
        return rawPost["id"] as? String
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
    
    fileprivate var currentUsername: String? {
        return userDefaults.string(forKey: "username")
    }
}

enum JSONKey: String {
    case access_token, username, user_id, data
}
