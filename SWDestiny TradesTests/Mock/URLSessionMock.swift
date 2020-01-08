//
//  URLSessionMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

final class URLSessionMock: URLSession {

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    var data: Data?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {

        let data = self.data
        let error = self.error

        return URLSessionDataTaskMock {
            let response = HTTPURLResponse(url: URL(string: ":D")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            completionHandler(data, response, error)
        }
    }
}
