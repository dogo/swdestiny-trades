//
//  CollectionCardWriterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class CollectionCardWriterTests: XCTestCase {

    private var database: DatabaseMock!
    private var sut: CollectionCardWriter!

    override func setUp() async throws {
        try await super.setUp()
        database = DatabaseMock()
        sut = CollectionCardWriter(database: database)
    }

    override func tearDown() async throws {
        database = nil
        sut = nil
        try await super.tearDown()
    }

    func test_addToCollection_createsCollectionAndAddsCard() async throws {
        try await sut.addToCollection(CardDTO.stub(code: "01001", name: "Captain Phasma"))

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(collections.count, 1)
        XCTAssertEqual(collections.first?.myCollection.map(\.code), ["01001"])
    }

    func test_addToCollection_reusesExistingCollection() async throws {
        try await sut.addToCollection(CardDTO.stub(code: "01001"))
        try await sut.addToCollection(CardDTO.stub(code: "01002"))

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(collections.count, 1)
        XCTAssertEqual(collections.first?.myCollection.count, 2)
    }

    func test_addToCollection_incrementsQuantityOnDuplicateCode() async throws {
        try await sut.addToCollection(CardDTO.stub(code: "01001"))
        try await sut.addToCollection(CardDTO.stub(code: "01001"))

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(collections.first?.myCollection.count, 1)
        XCTAssertEqual(collections.first?.myCollection.first?.quantity, 2)
    }

    func test_addToCollection_assignsFreshIdentityToCopy() async throws {
        let card = CardDTO.stub(code: "01001")
        let originalId = card.id

        try await sut.addToCollection(card)

        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        let stored = try XCTUnwrap(collections.first?.myCollection.first)
        XCTAssertNotEqual(stored.id, originalId)
    }
}
