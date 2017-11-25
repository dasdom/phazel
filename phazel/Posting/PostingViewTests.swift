//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import DDHFoundation

class PostingViewTests: XCTestCase {
    
    var sut: PostingView!
    
    override func setUp() {
        super.setUp()

        sut = PostingView()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_init_withCoder() {
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        
        let localSUT = PostingView(coder: archiver)
        
        XCTAssertNil(localSUT)
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
    
    func test_reset_clearsTextView() {
        guard let textView = sut.value(forKey: "textView") as? UITextView else { return XCTFail() }
        textView.text = "Foo bar"
        
        sut.update(with: nil)
        
        XCTAssertEqual(textView.text.count, 0)
    }
    
    func test_update_setsStatus() {
        let error = NSError(domain: "DDHTestError", code: 42, userInfo: [NSLocalizedDescriptionKey: "Foobar"])
        
        sut.update(with: error)
        
        if let imageView = sut.statusStackView.arrangedSubviews.first as? UIImageView  {
            XCTAssertNotNil(imageView.image)
        } else {
            XCTFail()
        }
        if let label = sut.statusStackView.arrangedSubviews.last as? UILabel {
            XCTAssertEqual(label.text, "Foobar")
        } else {
            XCTFail()
        }
    }
}
