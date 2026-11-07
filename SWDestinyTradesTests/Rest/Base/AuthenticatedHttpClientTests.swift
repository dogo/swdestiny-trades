//
//  AuthenticatedHttpClientTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class AuthenticatedHttpClientTests {

    private var client: HttpClientMock!
    private var authService: AuthServiceMock!
    private var sut: AuthenticatedHttpClient!

    init() {
        client = HttpClientMock()
        client.stub = [RemoteDeckDTO.stub()]
        authService = AuthServiceMock()
        sut = AuthenticatedHttpClient(client: client, authService: authService)
    }

    isolated deinit {
        sut = nil
        authService = nil
        client = nil
    }

    @Test
    func request_unauthorizedNeedingToken_refreshesAndRetries() async throws {
        client.errorsToThrow = [APIError.unauthorized]

        let decks = try await sut.request(DecksEndpoint(), decode: [RemoteDeckDTO].self)

        #expect(decks.count == 1)
        #expect(authService.refreshTokenCallCount == 1)
        #expect(client.requestCount == 2)
    }

    @Test
    func request_unauthorizedNotNeedingToken_throwsWithoutRefresh() async {
        client.errorsToThrow = [APIError.unauthorized]

        await #expect(throws: APIError.unauthorized) {
            _ = try await self.sut.request(SetListEndpoint(), decode: [RemoteDeckDTO].self)
        }
        #expect(authService.refreshTokenCallCount == 0)
        #expect(client.requestCount == 1)
    }

    @Test
    func request_refreshFails_throwsWithoutRetry() async {
        client.errorsToThrow = [APIError.unauthorized]
        authService.refreshTokenError = APIError.unauthorized

        await #expect(throws: APIError.unauthorized) {
            _ = try await self.sut.request(DecksEndpoint(), decode: [RemoteDeckDTO].self)
        }
        #expect(client.requestCount == 1)
    }
}
