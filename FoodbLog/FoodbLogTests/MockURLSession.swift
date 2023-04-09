//
//  MockURLSession.swift
//  FoodbLogTests
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//
@testable import FoodbLog
import Foundation
import XCTest

final class MockURLSession : URLSessionContract {

    var dataTaskCallCount = 0
    var capturedRequest : [URLRequest] = []
    var data : Data?
    var error : Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCallCount = dataTaskCallCount + 1
        capturedRequest.append(request)
        let data = self.data
        let error = self.error
        
        return DummyURLSessionDataTask {
            completionHandler(data, nil, error)
        }
    }
    
    /// Method to make sure the request made from client side similar with request send to handler
    func verifyDataTask(with request : URLRequest, file : StaticString = #file, line : UInt = #line) {
        XCTAssertEqual(request, capturedRequest.first, "networkRequest", file: file, line: line)
    }
}

final class DummyURLSessionDataTask : URLSessionDataTask {
    private let closure : ()-> Void
    
    init(_ closure : @escaping ()-> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

