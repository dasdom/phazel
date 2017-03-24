//  Created by dasdom on 18/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class AppDelegateTests: XCTestCase {
    
    var sut: AppDelegate!
    
    override func setUp() {
        super.setUp()

        sut = AppDelegate()
    }
    
    override func tearDown() {
        sut = nil

        super.tearDown()
    }
    
    func test_window_notNil() {
        XCTAssertNotNil(sut.window)
    }
    
    func test_window_isKey() {
        _ = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        XCTAssertEqual(sut.window, UIApplication.shared.keyWindow)
    }
}
