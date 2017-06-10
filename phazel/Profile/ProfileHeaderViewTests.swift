//  Created by dasdom on 04.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class ProfileHeaderViewTests: XCTestCase {
    
    var sut: ProfileHeaderView!
    
    override func setUp() {
        super.setUp()

        sut = ProfileHeaderView()
    }
    
    override func tearDown() {

        sut = nil
        
        super.tearDown()
    }
    
    func test_updateWithUser_setsUsername() {
        let user = User(dict: ["username": "foo"])
        
        sut.update(with: user)
        
        XCTAssertEqual(sut.usernameLabel.text, "@foo")
    }
    
    func test_updateWithUser_setsAvatar() {
        let user = User(dict: ["id": "42", "content": ["avatar_image": ["link": "foo"]]])
        let image = UIImage(named: "success")
        user.content?.avatarImage?.image = image
        
        sut.update(with: user)
        
        XCTAssertEqual(sut.avatarImageView.image, image)
    }
    
    func test_updateWithUser_setsName() {
        let user = User(dict: ["name": "Foo"])
        
        sut.update(with: user)
        
        XCTAssertEqual(sut.nameLabel.text, "Foo")
    }
}
