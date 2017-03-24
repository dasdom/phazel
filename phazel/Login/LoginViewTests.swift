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
    
    func test_init_withCoder() {
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        
        let localSUT = LoginView(coder: archiver)
        
        XCTAssertNil(localSUT)
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
    
    func test_usernameTextField_doesNot_translateAutoresizingMasks() {
        guard let textField = sut.value(forKey: "usernameTextField") as? UITextField else { return XCTFail() }
        
        XCTAssertFalse(textField.translatesAutoresizingMaskIntoConstraints)
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
    
    func test_passwordTextField_doesNot_translateAutoresizingMasks() {
        guard let textField = sut.value(forKey: "passwordTextField") as? UITextField else { return XCTFail() }
        
        XCTAssertFalse(textField.translatesAutoresizingMaskIntoConstraints)
    }

    func test_loginButton_isDescendantOf_SUT() {
        guard let button = sut.value(forKey: "loginButton") as? UIButton else { return XCTFail() }
        
        XCTAssertTrue(button.isDescendant(of: sut))
    }
    
    func test_button_doesNot_translateAutoresizingMasks() {
        guard let button = sut.value(forKey: "loginButton") as? UIButton else { return XCTFail() }
        
        XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints)
    }
    
    func test_button_hasNilTarget() {
        guard let button = sut.value(forKey: "loginButton") as? UIButton else { return XCTFail() }

        XCTAssertEqual(button.allTargets.count, 1)
    }
    
    func test_button_hasAction() {
        guard let button = sut.value(forKey: "loginButton") as? UIButton else { return XCTFail() }

        let action = button.actions(forTarget: nil, forControlEvent: .touchUpInside)?.first
        XCTAssertEqual(action, "login")
    }
    
    func test_setAnimated_true() {
        sut.set(animating: true)
        
        XCTAssertEqual(sut.loginButton.title(for: .normal), nil)
    }
    
    func test_setAnimated_false() {
        sut.set(animating: false)
        
        XCTAssertEqual(sut.loginButton.title(for: .normal), "Login")
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewTests {
    func test_shouldChangeCharactersInRange_disablesButton_WhenNoTextInUsernameTextField() {
        sut.usernameTextField.text = "a"
        sut.passwordTextField.text = "b"
        
        let shouldChange = sut.textField(sut.usernameTextField, shouldChangeCharactersIn: NSMakeRange(0, 1), replacementString: "")
        
        XCTAssertTrue(shouldChange)
        XCTAssertFalse(sut.loginButton.isEnabled)
    }
    
    func test_shouldChangeCharactersInRange_disablesButton_WhenNoTextInPasswordTextField() {
        sut.usernameTextField.text = "a"
        sut.passwordTextField.text = "b"
        
        let shouldChange = sut.textField(sut.passwordTextField, shouldChangeCharactersIn: NSMakeRange(0, 1), replacementString: "")
        
        XCTAssertTrue(shouldChange)
        XCTAssertFalse(sut.loginButton.isEnabled)
    }
    
    func test_shouldChangeCharactersInRange_enablesButton_WhenTextIsAddedToUsernameTextField() {
        sut.usernameTextField.text = ""
        sut.passwordTextField.text = "b"
        
        let shouldChange = sut.textField(sut.usernameTextField, shouldChangeCharactersIn: NSMakeRange(0, 0), replacementString: "a")
        
        XCTAssertTrue(shouldChange)
        XCTAssertTrue(sut.loginButton.isEnabled)
    }
    
    func test_shouldChangeCharactersInRange_enablesButton_WhenTextIsAddedToPasswordTextField() {
        sut.usernameTextField.text = "a"
        sut.passwordTextField.text = ""
        
        let shouldChange = sut.textField(sut.passwordTextField, shouldChangeCharactersIn: NSMakeRange(0, 0), replacementString: "b")
        
        XCTAssertTrue(shouldChange)
        XCTAssertTrue(sut.loginButton.isEnabled)
    }
}
