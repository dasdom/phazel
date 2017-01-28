//  Created by dasdom on 27/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class LoginViewTests: XCTestCase {
    
    var sut: LoginView!
    
    override func setUp() {
        super.setUp()

        sut = LoginView()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_username_returnsTextFrom_usernameTextField() {
        guard let textField = sut.value(forKey: "usernameTextField") as? UITextField else { return XCTFail() }
        textField.text = "Foo"
        
        let username = sut.username
        
        XCTAssertEqual(username, textField.text)
    }
    
    func test_usernameTextField_isDescendantOf_SUT() {
        guard let textField = sut.value(forKey: "usernameTextField") as? UITextField else { return XCTFail() }
       
        XCTAssertTrue(textField.isDescendant(of: sut))
    }
    
    func test_password_returnsTextFrom_passwordTextField() {
        guard let textField = sut.value(forKey: "passwordTextField") as? UITextField else { return XCTFail() }
        textField.text = "Bar"
        
        let password = sut.password
        
        XCTAssertEqual(password, textField.text)
    }
    
    func test_passwordTextField_isDescendantOf_SUT() {
        guard let textField = sut.value(forKey: "passwordTextField") as? UITextField else { return XCTFail() }
        
        XCTAssertTrue(textField.isDescendant(of: sut))
    }
    
    func test_passwordTextField_isSecure() {
        guard let textField = sut.value(forKey: "passwordTextField") as? UITextField else { return XCTFail() }
        
        XCTAssertTrue(textField.isSecureTextEntry)
    }

    
    func test_loginButton_isDescendantOf_SUT() {
        guard let button = sut.value(forKey: "loginButton") as? UIButton else { return XCTFail() }
        
        XCTAssertTrue(button.isDescendant(of: sut))
    }
}
