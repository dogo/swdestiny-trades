//
//  DeckServiceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class DeckServiceTests {

    private var client: HttpClientMock!
    private var sut: DeckService!

    init() {
        client = HttpClientMock()
        client.stub = [RemoteDeckDTO.stub()]
        sut = DeckService(client: client)
    }

    isolated deinit {
        sut = nil
        client = nil
    }

    @Test
    func retrieveDecks_mapsSlotsToCards() async throws {
        let decks = try await sut.retrieveDecks()

        let deck = try #require(decks.first)
        #expect(deck.id == "arh-1")
        #expect(deck.name == "Ewoks")
        #expect(deck.list.map(\.code) == ["05117", "11093"])
        #expect(deck.list.map(\.quantity) == [2, 1])
    }
}
