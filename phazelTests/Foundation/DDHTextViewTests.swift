//  Created by dasdom on 05/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import DDHFoundation

class DDHTextViewTests: XCTestCase {
    
    func test_init_setsTranslateAutoresizingMaskIntoConstraints_toFalse() {
        let sut = DDHTextView(frame: .zero, textContainer: nil)
        
        XCTAssertFalse(sut.translatesAutoresizingMaskIntoConstraints)
    }
    
    func test_init_withCoder() {
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        
        let sut = DDHTextView(coder: archiver)
        
        XCTAssertNil(sut)
    }
}
