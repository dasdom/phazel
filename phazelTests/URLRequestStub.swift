//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import XCTest

class URLRequestStub: URLProtocol {
    
    static var data: Data?
    static var expectation: XCTestExpectation?
    static var lastURL: URL?
    
    class func stub(with: Data, expect: XCTestExpectation) {
        data = with
        expectation = expect
        URLProtocol.registerClass(URLRequestStub.self)
    }
    
    override class func canInit(with: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        lastURL = request.url
        return request
    }
    
    override func startLoading() {
        guard let data = URLRequestStub.data else { fatalError() }
        DispatchQueue.global().async {
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
            URLProtocol.unregisterClass(URLRequestStub.self)
            DispatchQueue.main.async {
                URLRequestStub.expectation?.perform(#selector(XCTestExpectation.fulfill), with: nil, afterDelay: 0.001)
            }
        }
    }
    
    override func stopLoading() {
        
    }
    
    class func lastURLComponents() -> URLComponents? {
        guard let url = lastURL else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }
}
