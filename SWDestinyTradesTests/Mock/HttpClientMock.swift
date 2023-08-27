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
    var error: Bool = false
    var isCancelled = false

    var logger: NetworkingLogger {
        return NetworkingLogger(level: .none)
    }

    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {
        guard !error else {
            throw APIError.jsonParsingFailure
        }

        let decodable: T = JSONHelper.loadJSON(withFile: fileName)!
        return decodable
    }

    func cancelAllRequests() {
        isCancelled = true
    }
}
