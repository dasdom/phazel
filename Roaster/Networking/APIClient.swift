//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

public protocol APIClientProtocol {
    func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ())
    func post(text: String, completion: @escaping (Result<String>) -> ())
    func isLoggedIn() -> Bool
}

final public class APIClient: APIClientProtocol {
    let keychainManager: KeychainManagerProtocol
    let userDefaults: UserDefaults
    
    public init(keychainManager: KeychainManagerProtocol = KeychainManager(), userDefaults: UserDefaults = UserDefaults.standard) {
        self.keychainManager = keychainManager
        self.userDefaults = userDefaults
    }
    
    public func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        
        guard let url = URLCreator.auth.url() else { fatalError() }
        
        print("url: \(url)")
        
        let characterSet = CharacterSet(charactersIn: ":/?#[]@!$&'()*+,;=").inverted
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: characterSet),
            let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: characterSet) else {
                fatalError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyString = "username=\(encodedUsername)&password=\(encodedPassword)"
        
        if let secretsDict = secretsDict {
            for (key, value) in secretsDict {
                bodyString.append("&\(key)=\(value)")
            }
        }
        bodyString.append("&grant_type=password")
        bodyString.append("&scope=stream,write_post,follow,update_profile,presence,messages")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, taskError in
            
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print("dataString: \(dataString)")
            }
            
            var error = taskError
            if let meta = self.extractMeta(from: data) {
                if meta.code != 200 && meta.code != 201 {
                    error = NSError(domain: "DDHPnutAPIError", code: meta.code, userInfo: [NSLocalizedDescriptionKey: meta.errorMessage ?? "Unknown error"])
                }
            }
            
            DispatchQueue.main.async {
                let loginUser = self.extractLoginUser(from: data)
                let result = Result(value: loginUser, error: error)
                
                defer {
                    completion(result)
                }
                
                guard let token = self.extractToken(from: data) else { return }
                
                self.keychainManager.set(token: token, for: username)
                if let username = loginUser?.username {
                    self.userDefaults.set(username, forKey: "username")
                }
            }

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
            
            DispatchQueue.main.async {
                let postId = self.extractPostId(from: data)
                let result = Result(value: postId, error: error)
                completion(result)
            }
        }
        dataTask.resume()
    }
}

//MARK: - Helper
extension APIClient {
    public func isLoggedIn() -> Bool {
        guard let username = currentUsername else {
            print("No username")
            return false
        }
        guard let _ = keychainManager.token(for: username) else {
            print("No keychain item")
            return false
        }
        return true
    }
    
    fileprivate var secretsDict: [String:String]? {
        let url = Bundle.main.url(forResource: "secrets", withExtension: "json")
        guard let secretURL = url else { fatalError("No file at \(url)") }
        guard let secretData = try? Data(contentsOf: secretURL) else { fatalError() }
        let secretsDict = try? JSONSerialization.jsonObject(with: secretData, options: [])
        return secretsDict as? [String:String]
    }
}

extension APIClient {
    fileprivate func extractMeta(from data: Data?) -> Meta? {
        guard let jsonDict = jsonDict(from: data),
            let metaDict = jsonDict[JSONKey.meta.rawValue] as? [String:Any]
            else { return nil }
        
        return Meta(with: metaDict)
    }
    
    fileprivate func extractToken(from data: Data?) -> String? {
        guard let jsonDict = jsonDict(from: data),
            let rawToken = jsonDict[JSONKey.access_token.rawValue]
            else { return nil }
        return rawToken as? String
    }
    
    fileprivate func extractLoginUser(from data: Data?) -> LoginUser? {
        guard let jsonDict = jsonDict(from: data),
            let username = jsonDict[JSONKey.username.rawValue] as? String,
            let userId = jsonDict[JSONKey.user_id.rawValue] as? String
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
    case access_token, username, user_id, data, meta
}
