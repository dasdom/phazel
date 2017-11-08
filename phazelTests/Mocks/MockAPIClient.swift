//  Created by dasdom on 10.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import Roaster

class MockAPIClient: APIClientProtocol {
    
    var result: Result<[[String:Any]]>?
    var loginResult: Result<LoginUser>?
    var postResult: Result<String>?
    var dictResult: Result<[String:Any]>?
    var username: String?
    var password: String?
    var catchedBefore: Int?
    var catchedSince: Int?
    var lastProfilePostsUserId: String?
    var catchedGlobalSince: Int?
    var catchedGlobalBefore: Int?
    var postedText: String?
    var _isLoggedIn = false
    var lastFollowValue: Bool?
    var lastUserId: String?
    var catchedPostId: Int?
    
    init() {
        
    }
    
    init(result: Result<[[String:Any]]>) {
        self.result = result
    }
    
    init(result: Result<LoginUser>) {
        self.loginResult = result
    }
    
    init(result: Result<String>) {
        self.postResult = result
    }
    
    init(result: Result<[String:Any]>) {
        self.dictResult = result
    }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        self.username = username
        self.password = password
        completion(loginResult!)
    }
    
    func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ()) {
        postedText = text
        completion(postResult!)
    }
    
    func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ()) {
        catchedBefore = before
        catchedSince = since
        completion(result!)
    }
    
    func threadFor(postId: Int, completion: @escaping (Result<[[String : Any]]>) -> ()) {
        catchedPostId = postId
        completion(result!)
    }
    
    func globalPosts(before: Int?, since: Int?, completion: @escaping (Result<[[String : Any]]>) -> ()) {
        
        catchedGlobalBefore = before
        catchedGlobalSince = since
        completion(result!)
    }
    
    func profilePosts(userId: String, completion: @escaping (Result<[[String : Any]]>) -> ()) {
        lastProfilePostsUserId = userId
        completion(result!)
    }
    
    func user(id: String, completion: @escaping (Result<[String : Any]>) -> ()) {
        lastUserId = id
        guard let dictResult = dictResult else { return }
        completion(dictResult)
    }
    
    func follow(_ follow: Bool, userId: String, completion: @escaping (Result<[String : Any]>) -> ()) {
        lastFollowValue = follow
    }
    
    func isLoggedIn() -> Bool {
        return self._isLoggedIn
    }
}
