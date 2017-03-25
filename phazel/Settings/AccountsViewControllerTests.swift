//  Created by dasdom on 19/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import phazel
import Roaster

class AccountsViewControllerTests: XCTestCase {
    
    var sut: AccountsViewController!
    
    override func setUp() {
        super.setUp()

        sut = AccountsViewController(accounts: [Account(id: "23", username: "Foo"), Account(id: "42", username: "Bar")])
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_init_withCoder() {
        let archiver = NSKeyedArchiver(forWritingWith: NSMutableData())
        
        let localSUT = AccountsViewController(coder: archiver)
        
        XCTAssertNil(localSUT)
    }
    
    func test_cellForRowAt_returnsCell_1() {
        let localSUT = AccountsViewController(accounts: [Account(id: "23", username: "Foo")])
        
        let cell = localSUT.tableView(localSUT.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? AccountCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Foo")
    }
    
    func test_cellForRowAt_returnsCell_2() {
        let localSUT = AccountsViewController(accounts: [Account(id: "42", username: "Bar")])
        
        let cell = localSUT.tableView(localSUT.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        guard let unwrappedCell = cell as? AccountCell else { return XCTFail() }
        XCTAssertEqual(unwrappedCell.titleLabel.text, "Bar")
    }
    
    func test_didSelectRow_callsDelegateMethod_withAccount_1() {
        let delegateMock = AccountsViewControllerDelegateMock()
        sut.delegate = delegateMock
        
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(delegateMock.account, Account(id: "23", username: "Foo"))
    }
    
    func test_didSelectRow_callsDelegateMethod_withAccount_2() {
        let delegateMock = AccountsViewControllerDelegateMock()
        sut.delegate = delegateMock
        
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(delegateMock.account, Account(id: "42", username: "Bar"))
    }
    
    func test_addAccount_callsDelegateMethod() {
        let delegateMock = AccountsViewControllerDelegateMock()
        sut.delegate = delegateMock

        sut.addAccount()
        
        XCTAssertTrue(delegateMock.addAccountCalled)
    }
}

// MARK: - Mocks
extension AccountsViewControllerTests {
    class AccountsViewControllerDelegateMock: AccountsViewControllerDelegate {
        
        var account: Account?
        var addAccountCalled = false
        
        func didSelect(_ viewController: AccountsViewController, account: Account) {
            self.account = account
        }
        
        func addAccount(_ viewController: AccountsViewController) {
            addAccountCalled = true
        }
    }
}
