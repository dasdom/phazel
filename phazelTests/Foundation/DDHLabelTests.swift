//  Created by dasdom on 05/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import DDHFoundation

class DDHLabelTests: XCTestCase {
    
    func test_init_setsTranslatesAutoresizingMaskToConstraints_toFalse() {
        let sut = DDHLabel(frame: .zero)
        
        XCTAssertFalse(sut.translatesAutoresizingMaskIntoConstraints)
    }
    
    func test_init_withCoder() {
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        
        let sut = DDHLabel(coder: archiver)
        
        XCTAssertNil(sut)
    }
    
}
