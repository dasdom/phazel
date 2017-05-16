//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import CoreData
import Roaster
@testable import phazel

class PostingViewControllerTests: XCTestCase {
    
    var sut: PostingViewController!
    var mockView: MockView!
    var container: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        
        container = NSPersistentContainer(name: "Roaster")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container?.persistentStoreDescriptions = [description]
        
        container?.loadPersistentStores { _, _ in }

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
    
    func test_send_callsSendWithReply() {
        let dict = ["id": "23"]
        let post = Post(dict: dict)
        let localSUT = PostingViewController(contentView: mockView, replyTo: post)
        let delegateMock = MockPostingViewControllerDelegate()
        mockView.textToReturn = "Foo"
        localSUT.delegate = delegateMock
        
        localSUT.send()
        
        XCTAssertEqual(delegateMock.replyTo, "23")
    }
}

extension PostingViewControllerTests {
    class MockView: UIView, PostingViewProtocol {
        
        var resetted = false
        var textToReturn: String?
        
        var text: String? {
            get {
                return textToReturn
            }
            set {
                
            }
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
