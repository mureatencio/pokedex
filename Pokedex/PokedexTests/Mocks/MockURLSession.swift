//
//  MockURLSession.swift
//  Pokedex
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let data = mockData
        let error = mockError
        return MockURLSessionDataTask {
            completionHandler(data, nil, error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    func resume() {
        closure()
    }
}
