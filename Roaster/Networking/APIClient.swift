//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

public protocol APIClientProtocol {
    func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ())
    func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ())
    func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ())
    func isLoggedIn() -> Bool
}

final public class APIClient: APIClientProtocol {
    let keychainManager: KeychainManagerProtocol
    let userDefaults: UserDefaults
    
    public init(keychainManager: KeychainManagerProtocol = KeychainManager(), userDefaults: UserDefaults) {
        self.keychainManager = keychainManager
        self.userDefaults = userDefaults
    }
    
    public func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        
        guard let url = URLCreator.auth.url() else { fatalError() }
        
        let characterSet = CharacterSet(charactersIn: ":/?#[]@!$&'()*+,;= ").inverted
        let trimmedUsername = username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let encodedUsername = trimmedUsername.addingPercentEncoding(withAllowedCharacters: characterSet),
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
            
//            if let data = data {
//                let dataString = String(data: data, encoding: .utf8)
//                print("dataString: \(dataString)")
//            }
            
            var error = taskError
            if let meta = self.extractMeta(from: data) {
                if meta.code != 200 && meta.code != 201 {
                    error = NSError(domain: "DDHPnutAPIError", code: meta.code, userInfo: [NSLocalizedDescriptionKey: meta.errorMessage ?? "Unknown error"])
                }
            }
            
            DispatchQueue.main.async {
                let loginUser = self.extractLoginUser(from: data)
                var result = Result(value: loginUser, error: error)
                
                defer {
                    completion(result)
                }
                
                guard let token = self.extractToken(from: data) else { return }
                
                do {
                    try self.keychainManager.set(token: token, for: username)
                } catch {
                    result = Result(value: nil, error: error)
                }
                if let username = loginUser?.username {
                    self.userDefaults.set(username, forKey: UserDefaultsKey.username.rawValue)
                    if let id = loginUser?.id {
                        var accounts: [Any] = self.userDefaults.array(forKey: UserDefaultsKey.accounts.rawValue) ?? []
                        accounts.append([DictionaryKey.id.rawValue: id, DictionaryKey.username.rawValue: username])
                        self.userDefaults.set(accounts, forKey: UserDefaultsKey.accounts.rawValue)
                    }
                }
            }

        }
        dataTask.resume()
    }
    
    public func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ()) {
        
        guard let url = URLCreator.posts(before: before, since: since).url() else { fatalError() }
        guard let username = currentUsername else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoUserInUserDefaults", code: 1001, userInfo: nil)))
        }
        guard let token = keychainManager.token(for: username) else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoTokenInKeychain", code: 1002, userInfo: nil)))
        }
        print(">>> url: \(url)")
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in

            guard error == nil else {
                return completion(Result(value: nil, error: error))
            }
            
            guard let unwrappedData = data else {
                return completion(Result(value: nil, error: NSError(domain: "DDHDataNil", code: 1003, userInfo: nil)))
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                guard let jsonDict = json as? [String:Any], let arrayOfDicts = jsonDict["data"] as? [[String:Any]] else {
                    return completion(Result(value: nil, error: NSError(domain: "DDHJSONNotArrayOfDictionarys", code: 1004, userInfo: nil)))
                }
                
                let result = Result(value: arrayOfDicts, error: nil)
                completion(result)
            } catch {
                completion(Result(value: nil, error: error))
            }
        }
        dataTask.resume()
    }
    
    public func post(text: String, replyTo: String? = nil, completion: @escaping (Result<String>) -> ()) {
        
        guard let url = URLCreator.post.url() else { fatalError() }
        guard let username = currentUsername else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoUserInUserDefaults", code: 1001, userInfo: nil)))
        }
        guard let token = keychainManager.token(for: username) else {
            return completion(Result(value: nil, error: NSError(domain: "DDHNoTokenInKeychain", code: 1002, userInfo: nil)))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var postDict = ["text": text]
        if let replyTo = replyTo {
            postDict["reply_to"] = replyTo
        }
        guard let data = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            fatalError()
        }
        request.httpBody = data
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
//        let dataString = String(data: data, encoding: .utf8)
//        print("dataString: \(dataString)")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in
            
//            let dataString = String(data: data!, encoding: .utf8)
//            print("dataString: \(dataString)")
            
            DispatchQueue.main.async {
                let postId = self.extractPostId(from: data)
                let result = Result(value: postId, error: error)
                completion(result)
            }
        }
        dataTask.resume()
    }
    
    public func imageData(url: URL, completion: @escaping (Result<Data>) -> ()) {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            fatalError()
        }
        let imagesPath = "\(documentsPath)/images"
        if !FileManager.default.isWritableFile(atPath: imagesPath) {
            try! FileManager.default.createDirectory(at: URL(fileURLWithPath: imagesPath), withIntermediateDirectories: true, attributes: nil)
        }
        
        let fileName = url.lastPathComponent
        let pathURL = URL(fileURLWithPath: "\(imagesPath)/\(fileName)")
        if let data = try? Data(contentsOf: pathURL) {
            let result = Result(value: data, error: nil)
            completion(result)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in
            
            DispatchQueue.main.async {
                let result = Result(value: data, error: error)
                try! data?.write(to: pathURL, options: .atomic)
                completion(result)
            }
        }
        dataTask.resume()
    }
    
    public func data(url: URL, completion: @escaping (Result<Data>) -> ()) {
        
        var request = URLRequest(url: url)
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in
            
            DispatchQueue.main.async {
                let result = Result(value: data, error: error)
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
//        let url = Bundle.main.url(forResource: "secrets", withExtension: "json")
//        guard let secretURL = url else { fatalError("No file at \(url)") }
//        guard let secretData = try? Data(contentsOf: secretURL) else { fatalError() }
//        let secretsDict = try? JSONSerialization.jsonObject(with: secretData, options: [])
//        return secretsDict as? [String:String]
        return Secrets.secrets
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
    
//    fileprivate func extractPosts(from data: Data?) -> [Post]? {
//        guard let jsonDict = jsonDict(from: data) else { return nil }
//        guard let allRawPosts = jsonDict[JSONKey.data.rawValue] as? [[String:Any]] else { return nil }
//        
//        var posts: [Post] = []
//        for rawPost in allRawPosts {
//            if let post = Post(with: rawPost) {
//                posts.append(post)
//            }
//        }
//        return posts
//    }
    
    fileprivate func extractPostId(from data: Data?) -> String? {
        guard let jsonDict = jsonDict(from: data) else { return nil }
        guard let rawPost = jsonDict[JSONKey.data.rawValue] as? [String:Any] else { return nil }
        
        return rawPost["id"] as? String
    }
    
    private func jsonDict(from data: Data?) -> [String:Any]? {
        guard let data = data else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            fatalError("Invalid json")
        }
        return json as? [String:Any]
    }
    
    private func jsonArray(from data: Data?) -> [Any]? {
        guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            fatalError("Invalid json")
        }
        return json as? [Any]
    }
    
    fileprivate var currentUsername: String? {
        return userDefaults.string(forKey: UserDefaultsKey.username.rawValue)
    }
}
