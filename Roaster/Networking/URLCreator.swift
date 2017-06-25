//  Created by dasdom on 24/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

enum URLCreator {
    case auth
    case posts(before: Int?, since: Int?)
    case profilePosts(userId: String)
    case globalPosts(before: Int?, since: Int?)
    case post
    case follow(id: String)
    case user(id: String)
    
    func url() -> URL? {
        switch self {
        case .auth:
            let urlComponents = URLComponents(path: "/\(version)/oauth/access_token", queryItems: [])
            return urlComponents.url
        
        case .posts(let before, let since):
            var queryItems: [URLQueryItem] = []
            
            if let before = before {
                queryItems.append(URLQueryItem(name: "before_id", value: "\(before)"))
            } else if let since = since {
                queryItems.append(URLQueryItem(name: "since_id", value: "\(since)"))
                queryItems.append(URLQueryItem(name: "count", value: "200"))
            }
            
            let urlComponents = URLComponents(path: "/\(version)/posts/streams/unified", queryItems: queryItems)
            return urlComponents.url
        
        case .post:
            let urlComponents = URLComponents(path: "/\(version)/posts", queryItems: [])
            return urlComponents.url
        
        case .profilePosts(let userId):
            let urlComponents = URLComponents(path: "/\(version)/users/\(userId)/posts", queryItems: [])
            return urlComponents.url
            
        case .globalPosts(let before, let since):
            var queryItems: [URLQueryItem] = []
            
            if let before = before {
                queryItems.append(URLQueryItem(name: "before_id", value: "\(before)"))
            } else if let since = since {
                queryItems.append(URLQueryItem(name: "since_id", value: "\(since)"))
                queryItems.append(URLQueryItem(name: "count", value: "200"))
            }
            
            let urlComponents = URLComponents(path: "/\(version)/posts/streams/global", queryItems: queryItems)
            return urlComponents.url
            
        case .follow(let id):
            let urlComponents = URLComponents(path: "/\(version)/users/\(id)/follow", queryItems: [])
            return urlComponents.url
            
        case .user(let id):
            let urlComponents = URLComponents(path: "/\(version)/users/\(id)", queryItems: [])
            return urlComponents.url
            
        }
    }
}

extension URLCreator {
    fileprivate var version: String {
        return "v0"
    }
}

extension URLComponents {
    init(path: String, queryItems: [URLQueryItem]) {
        self.init()
        scheme = "https"
        host = "api.pnut.io"
        self.path = path
        if queryItems.count > 0 {
            self.queryItems = queryItems
        }
    }
}
