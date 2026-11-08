//
//  AuthenticatedHttpClient.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

final class AuthenticatedHttpClient: HttpClientProtocol {

    private let client: HttpClientProtocol
    private let authService: AuthServiceProtocol

    init(client: HttpClientProtocol, authService: AuthServiceProtocol) {
        self.client = client
        self.authService = authService
    }

    var logger: NetworkingLogger {
        client.logger
    }

    func request<T: Decodable & SendableMetatype>(_ endpoint: EndpointProtocol, decode: T.Type) async throws -> T {
        do {
            return try await client.request(endpoint, decode: T.self)
        } catch APIError.unauthorized where endpoint.needsToken {
            try await authService.refreshToken()
            return try await client.request(endpoint, decode: T.self)
        }
    }

    func cancelRequest(_ request: URLRequest?) {
        client.cancelRequest(request)
    }
}
