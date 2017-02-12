//  Created by dasdom on 29/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

public struct LoginUser: Equatable {
    let id: Int
    let username: String
    
    public init(id: Int, username: String) {
        self.id = id
        self.username = username
    }
    
    public static func ==(lhs: LoginUser, rhs: LoginUser) -> Bool {
        if lhs.username != rhs.username {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        return true
    }
}

