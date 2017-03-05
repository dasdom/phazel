//  Created by dasdom on 26/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest

class DDHTestCase: XCTestCase {
    
    struct UnexpectedNilError: Error {}
    
    public func True(_ expression: Bool?, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
        guard let foo = expression else { return XCTFail(message, file: file, line: line) }
        XCTAssertTrue(foo, message, file: file, line: line)
    }
    
//    public func Equal<T : Equatable>(_ expression1: T, _ expression2: T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
//        XCTAssertEqual(expression1, expression2, message, file: file, line: line)
//    }
//    
//    public func Equal<T : Equatable>(_ expression1: T?, _ expression2: T?, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
//        XCTAssertEqual(expression1, expression2, message, file: file, line: line)
//    }
//
//    public func Equal<T : Equatable>(_ expression1: ArraySlice<T>, _ expression2: ArraySlice<T>, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
//        XCTAssertEqual(expression1, expression2, message, file: file, line: line)
//    }
//    
//    public func Equal<T : Equatable>(_ expression1: ContiguousArray<T>, _ expression2: ContiguousArray<T>, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
//        XCTAssertEqual(expression1, expression2, message, file: file, line: line)
//    }
//    
//    public func Equal<T : Equatable>(_ expression1: [T], _ expression2: [T], _ message: String = "", file: StaticString = #file, line: UInt = #line) {
//        XCTAssertEqual(expression1, expression2, message, file: file, line: line)
//    }
    
}

extension DDHTestCase {
    func unwrap<T>(_ variable: T?, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) throws -> T {
        guard let variable = variable else {
            XCTFail(message(), file: file, line: line)
            throw UnexpectedNilError()
        }
        return variable
    }
    
    func body(of request: URLRequest?, contains string: String, file: StaticString = #file, line: UInt = #line) {
        guard let bodyData = request?.httpBody else { return XCTFail("No request or body", file: file, line: line) }
        let stringData = String(data: bodyData, encoding: .utf8)
        self.True(stringData?.contains(string))
    }
    
    func header(of request: URLRequest?, containsValue value: String, forKey key: String, file: StaticString = #file, line: UInt = #line) {
        guard let header = request?.allHTTPHeaderFields else { return XCTFail("No request or header fields", file: file, line: line) }
        self.True(header.contains(where: { (key, value) -> Bool in
            return key == "Authorization" && value == "Bearer 42"
        }), "Found header: \(header)")
    }
}
