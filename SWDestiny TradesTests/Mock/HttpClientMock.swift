//
//  HttpClientMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 22/09/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation
@testable import SWDestiny_Trades

final class HttpClientMock: HttpClientProtocol {
    var fileName = String()
    var error: Bool = false
    var isCancelled = false

    var logger: NetworkingLogger {
        return NetworkingLogger(level: .none)
    }

    func request<T>(_ request: URLRequest, decode: ((T) -> T)?, completion: @escaping (Result<T, APIError>) -> Void) where T: Decodable {
        guard !error else {
            return completion(.failure(.jsonParsingFailure))
        }

        let decodable: T = JSONHelper.loadJSON(withFile: fileName)!
        if let value = decode?(decodable) {
            return completion(.success(value))
        }
        return completion(.success(decodable))
    }

    func cancelAllRequests() {
        isCancelled = true
    }
}
