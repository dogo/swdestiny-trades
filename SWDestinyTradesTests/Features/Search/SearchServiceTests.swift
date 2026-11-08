//
//  SearchServiceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class SearchServiceTests: BaseTestCase {

    private var sut: SearchService!

    override init() async throws {
        try await super.init()
        sut = SearchService(client: mockHttpClient)
    }

    @Test
    func searchWithSuccess() async throws {
        mockHttpClient.stub = [CardDTO.stub(code: "01001")]

        let result = try await sut.search(query: "luke")

        let request = try #require(mockHttpClient.lastRequest)
        let components = try #require(request.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) })
        #expect(result.map(\.code) == ["01001"])
        #expect(components.path == "/api/find")
        #expect(components.queryItems == [URLQueryItem(name: "q", value: "luke")])
    }

    @Test
    func searchWithFailure() async {
        mockHttpClient.error = true

        await #expect(throws: APIError.invalidData) {
            _ = try await self.sut.search(query: "luke")
        }
    }
}
