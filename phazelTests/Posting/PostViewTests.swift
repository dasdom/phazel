//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class PostViewTests: XCTestCase {
    
    var sut: PostView!
    
    override func setUp() {
        super.setUp()

        sut = PostView()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_text_returnsTextFrom_textField() {
        guard let textView = sut.value(forKey: "textView") as? UITextView else { return XCTFail() }
        textView.text = "Foo bar"
        
        let text = sut.text
        
        XCTAssertEqual(text, textView.text)
    }
    
    func test_textView_isDescendant() {
        guard let textView = sut.value(forKey: "textView") as? UITextView else { return XCTFail() }

        XCTAssertTrue(textView.isDescendant(of: sut))
    }
    
    func test_sendButton_isDecendant() {
        guard let button = sut.value(forKey: "sendButton") as? DDHButton else { return XCTFail() }
        
        XCTAssertTrue(button.isDescendant(of: sut))
    }
    
    func test_sendButton_hasNilTarget() {
        guard let button = sut.value(forKey: "sendButton") as? UIButton else { return XCTFail() }
        
        XCTAssertEqual(button.allTargets.count, 1)
    }
    
    func test_sendButton_hasAction() {
        guard let button = sut.value(forKey: "sendButton") as? UIButton else { return XCTFail() }
        
        let action = button.actions(forTarget: nil, forControlEvent: .touchUpInside)?.first
        XCTAssertEqual(action, "send")
    }
}
