//
//  URLSessionMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

final class URLSessionMock {

    func build() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: sessionConfiguration)
    }
}

final class URLProtocolMock: URLProtocol {

    static var response: ((URLRequest) throws -> (HTTPResponse?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {

        do {
            guard var urlRequest = try Self.response?(request) else {
                client?.urlProtocol(self, didFailWithError: NSError(domain: "MyErrorDomain",
                                                                    code: 1,
                                                                    userInfo: ["reason": "Response creation failed"]))
                return
            }

            if let response = urlRequest.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = urlRequest.data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

struct HTTPResponse {

    var data: Data?
    let statusCode: Int

    lazy var response: HTTPURLResponse? = {
        let response = HTTPURLResponse(url: URL(string: "http://base.url.com")!,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        return response
    }()
}
