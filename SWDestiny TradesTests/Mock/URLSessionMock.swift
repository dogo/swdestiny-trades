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
    typealias CancelCompletionHandler = ([URLSessionDataTask], [URLSessionUploadTask], [URLSessionDownloadTask]) -> Void

    var data: Data?
    var error: Error?
    var statusCode: Int = 200
    var tasksCancelled: Bool = false

    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {

        let data = self.data
        let error = self.error
        let statusCode = self.statusCode

        return URLSessionDataTaskMock {
            let response = HTTPURLResponse(url: URL(string: ":D")!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)!
            completionHandler(data, response, error)
        }
    }

    override func getTasksWithCompletionHandler(_ completionHandler: @escaping CancelCompletionHandler) {
        tasksCancelled = true
        completionHandler([URLSessionDataTask](), [URLSessionUploadTask](), [URLSessionDownloadTask]())
    }
}
