//
//  CollectionCardWriterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class CollectionCardWriterTests {

    private var database: DatabaseMock!
    private var sut: CollectionCardWriter!

    init() async throws {
        database = DatabaseMock()
        sut = CollectionCardWriter(database: database)
    }

    deinit {
        database = nil
        sut = nil
    }

    @Test
    func addToCollection_createsCollectionAndAddsCard() async throws {
        try await sut.addToCollection(CardDTO.stub(code: "01001", name: "Captain Phasma"))

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(collections.count == 1)
        #expect(collections.first?.myCollection.map(\.code) == ["01001"])
    }

    @Test
    func addToCollection_reusesExistingCollection() async throws {
        try await sut.addToCollection(CardDTO.stub(code: "01001"))
        try await sut.addToCollection(CardDTO.stub(code: "01002"))

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(collections.count == 1)
        #expect(collections.first?.myCollection.count == 2)
    }

    @Test
    func addToCollection_incrementsQuantityOnDuplicateCode() async throws {
        try await sut.addToCollection(CardDTO.stub(code: "01001"))
        try await sut.addToCollection(CardDTO.stub(code: "01001"))

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        #expect(collections.first?.myCollection.count == 1)
        #expect(collections.first?.myCollection.first?.quantity == 2)
    }

    @Test
    func addToCollection_assignsFreshIdentityToCopy() async throws {
        let card = CardDTO.stub(code: "01001")
        let originalId = card.id

        try await sut.addToCollection(card)

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        let stored = try #require(collections.first?.myCollection.first)
        #expect(stored.id != originalId)
    }
}
