//
//  DeckListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class DeckListViewModelTests: BaseTestCase {

    private var sut: DeckListViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = DeckListViewModel(dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    private func makeDeck(name: String, cards: [CardDTO] = []) -> DeckDTO {
        let deck = DeckDTO()
        deck.name = name
        deck.list = cards
        return deck
    }

    // MARK: - Load

    func test_loadDecks_populatesItemsSortedByName() async {
        try? await populateTestData(objects: [
            makeDeck(name: "Zeta"),
            makeDeck(name: "Alpha")
        ])

        await sut.loadDecks()

        XCTAssertEqual(sut.items.map(\.name), ["Alpha", "Zeta"])
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadDecks_computesCardCounts() async {
        let deck = makeDeck(name: "Counted", cards: [
            CardDTO.stub(code: "01001", quantity: 2),
            CardDTO.stub(code: "01002", quantity: 3)
        ])
        try? await populateTestData(objects: [deck])

        await sut.loadDecks()

        XCTAssertEqual(sut.cardCounts[deck.id], 5)
    }

    // MARK: - Filtering

    func test_filterItems_byName() {
        let alpha = makeDeck(name: "Alpha Strike")
        let beta = makeDeck(name: "Beta Build")
        sut.updateItems([alpha, beta])

        sut.performFiltering(searchText: "Alpha")

        XCTAssertEqual(sut.filteredItems.map(\.name), ["Alpha Strike"])
    }

    // MARK: - Delete

    func test_delete_removesDeck() async {
        let keep = makeDeck(name: "Keep")
        let remove = makeDeck(name: "Remove")
        try? await populateTestData(objects: [keep, remove])
        await sut.loadDecks()

        await sut.delete(remove)

        XCTAssertEqual(sut.items.map(\.name), ["Keep"])
    }

    // MARK: - Rename

    func test_renameDeck_updatesName() async {
        let deck = makeDeck(name: "Old Name")
        try? await populateTestData(objects: [deck])
        await sut.loadDecks()

        await sut.renameDeck(deck, newName: "New Name")

        XCTAssertEqual(sut.items.map(\.name), ["New Name"])
    }

    func test_renameDeck_blankName_isNoOp() async {
        let deck = makeDeck(name: "Original")
        try? await populateTestData(objects: [deck])
        await sut.loadDecks()

        await sut.renameDeck(deck, newName: "   ")

        XCTAssertEqual(sut.items.map(\.name), ["Original"])
    }
}
