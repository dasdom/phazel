//  Created by dasdom on 05/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel

class SettingsCoordinatorTests: XCTestCase {
    
    var sut: SettingsCoordinator!
    var window: UIWindow!
    let userDefaults = UserDefaults()
    
    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        sut = SettingsCoordinator(window: window, userDefaults: userDefaults)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        
        super.tearDown()
    }
    
    func test_start_setsDelegateOfViewController() {
        sut.start()
        
        guard let viewController = sut.childViewControllers.last as? SettingsViewController else { return XCTFail() }
        XCTAssertTrue(viewController.delegate is SettingsCoordinator)
    }
    
    func test_start_setsSettingsItemsOfViewController() {
        sut.start()
        
        guard let viewController = sut.childViewControllers.last as? SettingsViewController else { return XCTFail() }
        guard let settingsItem = viewController.settingsItems.first else { return XCTFail() }
        guard case .string(let title, _) = settingsItem else { return XCTFail() }
        XCTAssertEqual(title, "Account")
    }
}
