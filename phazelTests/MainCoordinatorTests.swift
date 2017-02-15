//  Created by dasdom on 03/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
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
    
    func test_start_setsPostViewController_asRoot() {
        sut.start()
        
        XCTAssertTrue(window.rootViewController is PostViewController, "Found: \(window.visibleViewController)")
    }
    
}
