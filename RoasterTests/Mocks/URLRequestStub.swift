//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import XCTest

class URLRequestStub: URLProtocol {
    
    static var data: Data?
    static var expectation: XCTestExpectation?
    static var lastURL: URL?
    static var lastRequest: URLRequest?
    static var error: Error?
    
    class func stub(data: Data, expect: XCTestExpectation) {
        self.data = data
        error = nil
        expectation = expect
        URLProtocol.registerClass(URLRequestStub.self)
    }
    
    class func stub(error: Error, expect: XCTestExpectation) {
        self.error = error
        data = nil
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
        if let data = URLRequestStub.data {
            DispatchQueue.global().async {
                self.client?.urlProtocol(self, didLoad: data)
                URLRequestStub.data = nil
                var theRequest = self.request
                theRequest.httpBody = self.extractBody(from: self.request.httpBodyStream)
                URLRequestStub.lastRequest = theRequest
                self.client?.urlProtocolDidFinishLoading(self)
                URLProtocol.unregisterClass(URLRequestStub.self)
                DispatchQueue.main.async {
                    URLRequestStub.expectation?.perform(#selector(XCTestExpectation.fulfill), with: nil, afterDelay: 0.05)
                }
            }
        } else if let error = URLRequestStub.error {
            DispatchQueue.global().async {
                self.client?.urlProtocol(self, didFailWithError: error)
                URLRequestStub.error = nil
                URLProtocol.unregisterClass(URLRequestStub.self)
                DispatchQueue.main.async {
                    URLRequestStub.expectation?.perform(#selector(XCTestExpectation.fulfill), with: nil, afterDelay: 0.05)
                }
            }
        } else {
            fatalError()
        }
    }
    
    override func stopLoading() {
        
    }
    
    class func lastURLComponents() -> URLComponents? {
        guard let url = lastURL else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }
    
    func extractBody(from stream: InputStream?) -> Data? {
        
        guard let stream = stream else { return nil }
        
        let bufferSize = 1024
        var buffer = Array<UInt8>(repeating: 0, count: bufferSize)
        
        stream.open()
        let bytesRead = stream.read(&buffer, maxLength: bufferSize)
        stream.close()
        if bytesRead >= 0 {
            return Data(bytes: &buffer, count: bytesRead)
        } else {
            return nil
        }
    }
}
