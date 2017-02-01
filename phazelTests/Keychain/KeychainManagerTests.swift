//  Created by dasdom on 27/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class KeychainManagerTests: XCTestCase {
    
    func test_TokenCanBeStored_AndRead() {
        let sut = KeychainManager()
        
        sut.set(token: "foo", for: "bar")
        let secondSut = KeychainManager()
        let token = secondSut.token(for: "bar")
        
        XCTAssertEqual(token, "foo")
    }
    
    func test_CanDeleteToken() {
        let sut = KeychainManager()
        
        sut.set(token: "foo", for: "bar")
        sut.deleteToken(for: "bar")
        let token = sut.token(for: "bar")
        
        XCTAssertNil(token)
    }
    
}
