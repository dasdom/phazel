//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class PostViewControllerTests: XCTestCase {
    
    var sut: PostViewController!
    
    override func setUp() {
        super.setUp()

        let mockView = MockView()
        sut = PostViewController(contentView: mockView)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_setsView() {
        XCTAssertTrue(sut.view is MockView)
    }
    
    func test_send_callsAPIClientMethod() {
        let mockAPIClient = MockAPIClient(result: Result(value: "42", error: nil))
        let localSUT = PostViewController(contentView: MockView(), apiClient: mockAPIClient)
        
        localSUT.send()
        
        XCTAssertEqual(mockAPIClient.text, "Foo")
    }
    
    func test_send_callsDelegateMethod_whenSuccessful() {
        let mockAPIClient = MockAPIClient(result: Result(value: "42", error: nil))
        let localSUT = PostViewController(contentView: MockView(), apiClient: mockAPIClient)
        let mockDelegate = MockPostViewControllerDelegate()
        localSUT.delegate = mockDelegate
        
        localSUT.send()
        
        XCTAssertEqual(mockDelegate.postId, "42")
    }
    
    func test_send_callsDelegateMethod_whenFailed() {
        let result = Result<String>(value: nil, error: NSError(domain: "TestError", code: 1234, userInfo: nil))
        let localSUT = PostViewController(contentView: MockView(), apiClient: MockAPIClient(result: result))
        let mockDelegate = MockPostViewControllerDelegate()
        localSUT.delegate = mockDelegate
        
        localSUT.send()
        
        guard case .failure(let error) = result else { return XCTFail() }
        XCTAssertEqual(mockDelegate.error as? NSError, error as NSError)
    }
}

extension PostViewControllerTests {
    class MockView: UIView, PostViewProtocol {
        var text: String? {
            return "Foo"
        }
    }
    
    class MockAPIClient: APIClientProtocol {
        
        let result: Result<String>
        var text: String?
        
        init(result: Result<String>) {
            self.result = result
        }
        
        func login(username: String, password: String, completion: @escaping (Result<LoginUser>) -> ()) {
            
        }
        
        func post(text: String, completion: @escaping (Result<String>) -> ()) {
            self.text = text
            completion(result)
        }
    }
    
    class MockPostViewControllerDelegate: PostViewControllerDelegate {
        
        var postId: String?
        var error: Error?
        
        func postDidSucceed(viewController: PostViewController, with postId: String) {
           self.postId = postId
        }
        
        func postDidFail(viewController: PostViewController, with error: Error) {
            self.error = error
        }
    }
}
