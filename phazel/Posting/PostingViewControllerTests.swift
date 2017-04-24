//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class PostingViewControllerTests: XCTestCase {
    
    var sut: PostingViewController!
    var mockView: MockView!
    
    override func setUp() {
        super.setUp()

        mockView = MockView()
        sut = PostingViewController(contentView: mockView)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_setsView() {
        XCTAssertTrue(sut.view is MockView)
    }
    
    func test_send_callsSendOfDelegate() {
        let delegateMock = MockPostingViewControllerDelegate()
        sut.delegate = delegateMock
        mockView.textToReturn = "Foo"
        
        sut.send()
        
        XCTAssertEqual(delegateMock.text, "Foo")
    }
    
//    func test_send_callsAPIClientMethod() {
//        let mockAPIClient = MockAPIClient(result: Result(value: "42", error: nil))
//        let localSUT = PostingViewController(contentView: MockView())
//        
//        localSUT.send()
//        
//        XCTAssertEqual(mockAPIClient.text, "Foo")
//    }
//    
//    func test_send_callsDelegateMethod_whenSuccessful() {
//        let mockAPIClient = MockAPIClient(result: Result(value: "42", error: nil))
//        let localSUT = PostingViewController(contentView: MockView())
//        let mockDelegate = MockPostingViewControllerDelegate()
//        localSUT.delegate = mockDelegate
//        
//        localSUT.send()
//        
//        XCTAssertEqual(mockDelegate.postId, "42")
//    }
//    
//    func test_send_callsDelegateMethod_whenFailed() {
//        let result = Result<String>(value: nil, error: NSError(domain: "TestError", code: 1234, userInfo: nil))
//        let localSUT = PostingViewController(contentView: MockView())
//        let mockDelegate = MockPostingViewControllerDelegate()
//        localSUT.delegate = mockDelegate
//        
//        localSUT.send()
//        
//        guard case .failure(let error) = result else { return XCTFail() }
//        guard let catchedError = mockDelegate.error else { return XCTFail() }
//        XCTAssertEqual(catchedError as NSError, error as NSError)
//    }
//    
//    func test_send_callsReset_whenSuccessful() {
//        let mockAPIClient = MockAPIClient(result: Result(value: "42", error: nil))
//        let mockView = MockView()
//        let localSUT = PostingViewController(contentView: mockView, apiClient: mockAPIClient)
//        
//        localSUT.send()
//        
//        XCTAssertTrue(mockView.resetted)
//    }
//    
//    func test_send_doesNotCallReset_whenFailed() {
//        let mockAPIClient = MockAPIClient(result: Result<String>(value: nil, error: NSError(domain: "TestError", code: 1234, userInfo: nil)))
//        let mockView = MockView()
//        let localSUT = PostingViewController(contentView: mockView, apiClient: mockAPIClient)
//        
//        localSUT.send()
//        
//        XCTAssertFalse(mockView.resetted)
//    }
    
//    func test_hasLeftNavigationItem() {
//        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
//    }
}

extension PostingViewControllerTests {
    class MockView: UIView, PostingViewProtocol {
        
        var resetted = false
        var textToReturn: String?
        
        var text: String? {
            return "Foo"
        }
        
        func update(with error: Error?) {
            if error == nil {
                resetted = true
            }
        }
        
        func setFirstResponder() {
            
        }
        
        var topView: UIView {
            return UIView()
        }
        
        func set(animating: Bool) {
            
        }

    }
    
    class MockPostingViewControllerDelegate: PostingViewControllerDelegate {
        
        var text: String?
        var replyTo: String?
        
        func send(text: String, replyTo: String?) {
            self.text = text
            self.replyTo = replyTo
        }
    }
}
