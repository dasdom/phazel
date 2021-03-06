//  Created by dasdom on 09.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
import Roaster
@testable import phazel

class ProfileCoordinatorTests: XCTestCase {
    
    var sut: ProfileCoordinator!
    var apiClient: MockAPIClient!
    let userDefaults = UserDefaults()
    
    override func setUp() {
        super.setUp()
        
        apiClient = MockAPIClient(result: Result(value: [["foo": 23]], error: nil))
        sut = ProfileCoordinator(rootViewController: UINavigationController(), apiClient: apiClient, userDefaults: userDefaults)
    }
    
    override func tearDown() {
        sut = nil
        apiClient = nil
        
        super.tearDown()
    }
}

// MARK: - General
extension ProfileCoordinatorTests {
    func test_start_setsViewController() {
        sut.start()
        guard let viewController = sut.viewController else { return XCTFail() }
        
        XCTAssertTrue(viewController is ProfileViewController)
    }
    
    func test_start_setsDelegate() {
        sut.start()
        guard let viewController = sut.viewController else { return XCTFail() }
        
        XCTAssertTrue(viewController.delegate is ProfileCoordinator)
    }
    
    func test_start_setsDataSourceOfCollectionView() {
        sut.start()
        
        guard let viewController = sut.viewController else { return XCTFail() }
        guard let dataSource = viewController.tableView?.dataSource else { return XCTFail() }
        XCTAssertTrue(dataSource is TableViewDataSource<PostsCoordinator>)
    }
    
    func test_start_setsDataSourceOfViewController() {
        sut.start()
        
        guard let viewController = sut.viewController else { return XCTFail() }
        XCTAssertNotNil(viewController.dataSource)
    }
}
