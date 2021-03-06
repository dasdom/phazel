//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class MainCoordinatorTests: XCTestCase {
    
    var sut: MainCoordinator!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.makeKeyAndVisible()
        sut = MainCoordinator(window: window)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        
        super.tearDown()
    }
    
//    func test_start_setsPostViewController_toVisible() {
//        sut.start()
//        
//        XCTAssertTrue(window.visibleViewController is PostsCollectionViewController)
//        XCTAssertNotNil(sut.timelineCoordinator)
//    }
}
