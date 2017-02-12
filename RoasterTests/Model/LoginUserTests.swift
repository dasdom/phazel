//  Created by dasdom on 29/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import Roaster

class LoginUserTests: XCTestCase {
    
    func test_equal_loginUser_areEqual() {
        let loginUser1 = LoginUser(id: 23, username: "foo")
        let loginUser2 = LoginUser(id: 23, username: "foo")
        
        XCTAssertEqual(loginUser1, loginUser2)
    }
    
    func test_loginUser_withDifferent_usernames_areDifferent() {
        let loginUser1 = LoginUser(id: 23, username: "foo")
        let loginUser2 = LoginUser(id: 23, username: "bar")
        
        XCTAssertNotEqual(loginUser1, loginUser2)
    }
    
    func test_loginUser_withDifferent_ids_areDifferent() {
        let loginUser1 = LoginUser(id: 42, username: "foo")
        let loginUser2 = LoginUser(id: 23, username: "foo")
        
        XCTAssertNotEqual(loginUser1, loginUser2)
    }
}
