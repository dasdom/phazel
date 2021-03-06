//  Created by dasdom on 30/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    
    override func setUp() {
        super.setUp()

        let mockView = MockView()
        sut = LoginViewController(contentView: mockView, apiClient: APIClient(userDefaults: UserDefaults()))
        
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_setsView() {
        XCTAssertTrue(sut.view is MockView)
    }
    
    func test_login_callsAPIClientMethod() {
        let result = Result(value: LoginUser(id: "23", username: "foo"), error: nil)
        let mockAPIClient = MockAPIClient(result: result)
        let localSUT = LoginViewController(contentView: MockView(), apiClient: mockAPIClient)
        
        localSUT.login()
        
        XCTAssertEqual(mockAPIClient.username, "Foo")
        XCTAssertEqual(mockAPIClient.password, "Bar")
    }
    
    func test_login_callsDelegateMethod_whenSuccessful() {
        let result = Result(value: LoginUser(id: "23", username: "foo"), error: nil)
        let localSUT = LoginViewController(contentView: MockView(), apiClient: MockAPIClient(result: result))
        let mockDelegate = MockLoginViewControllerDelegate()
        localSUT.delegate = mockDelegate
        
        localSUT.login()
    
        guard case .success(let user) = result else { return XCTFail() }
        XCTAssertEqual(mockDelegate.loginUser, user)
    }
    
    func test_login_callsDelegateMethod_whenFailed() {
        let result = Result<LoginUser>(value: nil, error: NSError(domain: "TestError", code: 1234, userInfo: nil))
        let localSUT = LoginViewController(contentView: MockView(), apiClient: MockAPIClient(result: result))
        let mockDelegate = MockLoginViewControllerDelegate()
        localSUT.delegate = mockDelegate

        localSUT.login()
        
        guard case .failure(let error) = result else { return XCTFail() }
        guard let catchedError = mockDelegate.error else { return XCTFail() }
        XCTAssertEqual(catchedError as NSError, error as NSError)
    }
}

extension LoginViewControllerTests {
    class MockView: UIView, LoginViewProtocol {
        var username: String? {
            return "Foo"
        }
        
        var password: String? {
            return "Bar"
        }
        
        func setFirstResponder() {
            
        }
        
        func set(animating: Bool) {

        }
    }
    
    class MockLoginViewControllerDelegate: LoginViewControllerDelegate {
        
        var loginUser: LoginUser? = nil
        var error: Error? = nil
        
        func loginDidSucceed(viewController: LoginViewController, with loginUser: LoginUser) {
            self.loginUser = loginUser
        }
        
        func loginDidFail(viewController: LoginViewController, with error: Error) {
            self.error = error
        }
    }
}
