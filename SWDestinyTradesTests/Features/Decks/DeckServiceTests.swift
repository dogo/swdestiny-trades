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

    @Test
    func saveDeck_putsSlotsAndAffiliationAsForm() async throws {
        client.stub = try JSONDecoder().decode(SaveDeckResponseDTO.self, from: Data(#"{"success":true,"msg":12}"#.utf8))
        let deck = DeckDTO()
        deck.name = "Phasma & Co"
        deck.list = [
            CardDTO.stub(affiliationCode: "neutral", code: "01020", hasDie: false, quantity: 2),
            CardDTO.stub(affiliationCode: "villain", code: "01001", quantity: 1, isElite: true)
        ]

        try await sut.saveDeck(deck, remoteID: 12)

        let request = try #require(client.lastRequest)
        let body = try #require(request.httpBody.flatMap { String(data: $0, encoding: .utf8) })
        let form = Dictionary(uniqueKeysWithValues: body.split(separator: "&").map { pair in
            let parts = pair.split(separator: "=", maxSplits: 1).map { String($0).removingPercentEncoding ?? "" }
            return (parts[0], parts[1])
        })
        #expect(request.httpMethod == "PUT")
        #expect(request.url?.path == "/api/deck/save/12")
        #expect(form["name"] == "Phasma & Co")
        #expect(form["affiliation_code"] == "villain")
        #expect(form["slots"] == #"{"01001":{"dice":2,"quantity":1},"01020":{"dice":0,"quantity":2}}"#)
    }

    @Test
    func saveDeck_rejectedByServer_throwsItsMessage() async throws {
        client.stub = try JSONDecoder().decode(SaveDeckResponseDTO.self, from: Data(#"{"success":false,"msg":"Slots missing"}"#.utf8))

        await #expect(throws: SaveDeckError.rejected("Slots missing")) {
            try await self.sut.saveDeck(DeckDTO(), remoteID: 12)
        }
    }

    @Test
    func saveDeck_waitsForThePreviousSaveBeforeSending() async throws {
        client.stub = try JSONDecoder().decode(SaveDeckResponseDTO.self, from: Data(#"{"success":true,"msg":12}"#.utf8))
        var finished: [Int] = []
        client.onRequest = { [client] in
            let call = client?.requestCount ?? 0
            if call == 1 {
                try? await Task.sleep(for: .milliseconds(100))
            }
            finished.append(call)
        }

        async let first: Void = sut.saveDeck(DeckDTO(), remoteID: 12)
        async let second: Void = sut.saveDeck(DeckDTO(), remoteID: 12)
        _ = try await (first, second)

        #expect(finished == [1, 2])
    }

    @Test
    func deleteDeck_sendsDeleteForTheRemoteID() async throws {
        client.stub = try JSONDecoder().decode(SaveDeckResponseDTO.self, from: Data(#"{"success":true,"msg":12}"#.utf8))

        try await sut.deleteDeck(remoteID: 12)

        #expect(client.lastRequest?.httpMethod == "DELETE")
        #expect(client.lastRequest?.url?.path == "/api/deck/delete/12")
    }
}
