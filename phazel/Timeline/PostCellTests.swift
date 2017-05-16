//  Created by dasdom on 20/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class PostCellTests: XCTestCase {
    
    var sut: PostCell!

    override func setUp() {
        super.setUp()
        
        sut = PostCell(style: .default, reuseIdentifier: "Cell")
    }
    
    override func tearDown() {

        sut = nil
        
        super.tearDown()
    }
    
    func test_has_usernameLableSubview() {
        let usernameLabelIsSubview = sut.usernameLabel.isDescendant(of: sut.contentView)
        XCTAssertTrue(usernameLabelIsSubview)
    }
    
    func test_configure_setsUsername() {
        let dict = ["user": ["username": "foo"]]
        let post = Post(dict: dict)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.usernameLabel.text, "foo")
    }
    
    func test_has_textLabelSubview() {
        let textLabelIsSubview = sut.postTextView.isDescendant(of: sut.contentView)
        XCTAssertTrue(textLabelIsSubview)
    }
    
    func test_configure_setsText() {
        let dict = ["content": ["text": "foo"]]
        let post = Post(dict: dict)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.postTextView.text, "foo")
    }
    
    func test_has_sourceLabelSubview() {
        let sourceLabelIsSubview = sut.sourceLabel.isDescendant(of: sut.contentView)
        XCTAssertTrue(sourceLabelIsSubview)
    }
    
    func test_configure_setsSource() {
        let dict = ["source": ["name": "Foo"]]
        let post = Post(dict: dict)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.sourceLabel.text, "via Foo")
    }
    
    func test_has_sourceTimeLabelSubview() {
        let timeLabelIsSubview = sut.timeLabel.isDescendant(of: sut.contentView)
        XCTAssertTrue(timeLabelIsSubview)
    }
    
    func test_configure_setsMinutes() {
        let dateFormatter = ISO8601DateFormatter()
        let fourMinutesAgo = Date(timeIntervalSinceNow: -4 * 60)
        let dateString = dateFormatter.string(from: fourMinutesAgo)
        let dict = ["created_at": dateString]
        let post = Post(dict: dict)

        sut.configure(with: post)
        
        XCTAssertEqual(sut.timeLabel.text, "4m")
    }
    
    func test_configure_setsHours() {
        let dateFormatter = ISO8601DateFormatter()
        let fourMinutesAgo = Date(timeIntervalSinceNow: -4 * 60 * 60)
        let dateString = dateFormatter.string(from: fourMinutesAgo)
        let dict = ["created_at": dateString]
        let post = Post(dict: dict)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.timeLabel.text, "4h")
    }
    
    func test_configure_setsDays() {
        let dateFormatter = ISO8601DateFormatter()
        let fourMinutesAgo = Date(timeIntervalSinceNow: -4 * 24 * 60 * 60)
        let dateString = dateFormatter.string(from: fourMinutesAgo)
        let dict = ["created_at": dateString]
        let post = Post(dict: dict)
        
        sut.configure(with: post)
        
        XCTAssertEqual(sut.timeLabel.text, "4d")
    }
    
    func test_has_avatarImageViewSubview() {
        let avatarImageViewIsSubview = sut.avatarImageView.isDescendant(of: sut.contentView)
        XCTAssertTrue(avatarImageViewIsSubview)
    }
    
    func test_has_replyButton() {
        let replyButtonIsSubview = sut.replyButton.isDescendant(of: sut.contentView)
        XCTAssertTrue(replyButtonIsSubview)
    }
    
    func test_replyButton_hasReplyActionForNilTarget() {
        XCTAssertEqual(sut.replyButton.actions(forTarget: nil, forControlEvent: .touchUpInside)?.first, "replyWithSender:")
    }
}
