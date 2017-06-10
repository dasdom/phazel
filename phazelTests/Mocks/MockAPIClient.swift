//
//  MockAPIClient.swift
//  phazelTests
//
//  Created by dasdom on 10.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import Roaster

class MockAPIClient: APIClientProtocol {
    
    let result: Result<[[String:Any]]>
    var catchedBefore: Int?
    var catchedSince: Int?
    var catchedUserId: String?
    
    init(result: Result<[[String:Any]]>) {
        self.result = result
    }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
        
    }
    
    func post(text: String, replyTo: String?, completion: @escaping (Result<String>) -> ()) {
        
    }
    
    func posts(before: Int?, since: Int?, completion: @escaping (Result<[[String:Any]]>) -> ()) {
        catchedBefore = before
        catchedSince = since
        completion(result)
    }
    
    func profilePosts(userId: String, completion: @escaping (Result<[[String : Any]]>) -> ()) {
        catchedUserId = userId
        completion(result)
    }
    
    func isLoggedIn() -> Bool {
        return false
    }
}
