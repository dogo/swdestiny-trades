//
//  HttpClientMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 22/09/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class HttpClientMock: HttpClientProtocol {
    var fileName = String()
    var stub: Decodable?
    var error: Bool = false
    var errorsToThrow: [Error] = []
    var isCancelled = false
    var onRequest: (() async -> Void)?
    private(set) var lastRequest: URLRequest?
    private(set) var requestCount = 0

    var logger: NetworkingLogger {
        return NetworkingLogger(level: .none)
    }

    func request<T: Decodable & SendableMetatype>(_ endpoint: EndpointProtocol, decode: T.Type) async throws -> T {
        lastRequest = endpoint.request
        requestCount += 1
        await onRequest?()

        if !errorsToThrow.isEmpty {
            throw errorsToThrow.removeFirst()
        }

        if !error, let stub = stub as? T {
            return stub
        }

        guard !error, !fileName.isEmpty, let decodable: T = JSONHelper.loadJSON(withFile: fileName) else {
            throw APIError.invalidData
        }
        return decodable
    }

    func cancelRequest(_ request: URLRequest?) {
        isCancelled = true
    }
}
