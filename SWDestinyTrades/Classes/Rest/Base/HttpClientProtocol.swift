//
//  HttpClientProtocol.swift
//  SWDestiny Trades
//
//  Created by diogo.autilio on 22/09/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

protocol HttpClientProtocol {
    var logger: NetworkingLogger { get }

    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T

    func request<T: Decodable>(_ endpoint: EndpointProtocol, decode: T.Type) async throws -> T

    func cancelRequest(_ request: URLRequest?)
}

extension HttpClientProtocol {
    func request<T: Decodable>(_ endpoint: EndpointProtocol, decode: T.Type) async throws -> T {
        try await request(endpoint.request, decode: T.self)
    }
}
