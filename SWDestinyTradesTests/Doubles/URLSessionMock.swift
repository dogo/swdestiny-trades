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

    static var response: ((URLRequest) throws -> HTTPResponse?)?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {

        do {
            guard let httpResponse = try Self.response?(request) else {
                client?.urlProtocol(self, didFailWithError: NSError(domain: "MockErrorDomain",
                                                                    code: -1,
                                                                    userInfo: [NSLocalizedDescriptionKey: "No response provided"]))
                return
            }

            if let response = httpResponse.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            } else {
                client?.urlProtocol(self, didFailWithError: NSError(domain: "MockErrorDomain",
                                                                    code: -1,
                                                                    userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"]))
                return
            }

            if let data = httpResponse.data {
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
    var response: URLResponse?

    init(data: Data?, statusCode: Int, isHTTP: Bool = true) {
        if isHTTP {
            response = HTTPURLResponse(url: URL(string: "http://base.url.com")!,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        } else {
            response = URLResponse(url: URL(string: "http://base.url.com")!,
                                   mimeType: nil,
                                   expectedContentLength: 0,
                                   textEncodingName: nil)
        }
        self.data = data
    }
}
