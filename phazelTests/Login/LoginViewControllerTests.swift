//  Created by dasdom on 30/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    
    override func setUp() {
        super.setUp()

        let mockView = MockView()
        sut = LoginViewController(contentView: mockView)
        
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
        let mockView = MockView()
        let result = Result(value: LoginUser(id: 23, username: "foo"), error: nil)
        let mockAPIClient = MockAPIClient(result: result)
        let localSUT = LoginViewController(contentView: mockView, apiClient: mockAPIClient)
        
        localSUT.login()
        
        XCTAssertEqual(mockAPIClient.username, "Foo")
        XCTAssertEqual(mockAPIClient.password, "Bar")
    }
    
    func test_login_callsDelegateMethod_whenSuccessful() {
        let mockView = MockView()
        let result = Result(value: LoginUser(id: 23, username: "foo"), error: nil)
        let localSUT = LoginViewController(contentView: mockView, apiClient: MockAPIClient(result: result))
        let mockDelegate = MockLoginViewControllerDelegate()
        localSUT.delegate = mockDelegate
        
        localSUT.login()
    
        guard case .success(let user) = result else { return XCTFail() }
        XCTAssertEqual(mockDelegate.loginUser, user)
    }
    
    func test_login_callsDelegateMethod_whenFailed() {
        let mockView = MockView()
        let result = Result<LoginUser>(value: nil, error: NSError(domain: "TestError", code: 1234, userInfo: nil))
        let localSUT = LoginViewController(contentView: mockView, apiClient: MockAPIClient(result: result))
        let mockDelegate = MockLoginViewControllerDelegate()
        localSUT.delegate = mockDelegate

        localSUT.login()
        
        guard case .failure(let error) = result else { return XCTFail() }
        XCTAssertEqual(mockDelegate.error as? NSError, error as NSError)
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
    }
    
    class MockAPIClient: APIClientProtocol {
        
        let result: Result<LoginUser>
        var username: String?
        var password: String?
        
        init(result: Result<LoginUser>) {
            self.result = result
        }
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
            self.username = username
            self.password = password
            completion(result)
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
