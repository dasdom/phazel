//  Created by dasdom on 08/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import Roaster
@testable import phazel

class MockKeychainManager: KeychainManagerProtocol {
    
    var token: String?
    
    init(token: String? = nil) {
        self.token = token
    }
    
    func set(token: String, for username: String) {
        self.token = token
    }
    
    func token(for username: String) -> String? {
        return token
    }
    
    func deleteToken(for username: String) {
        
    }
}
