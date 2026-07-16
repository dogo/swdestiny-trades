//
//  DeckListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Observation
import Testing

@testable import SWDestinyTrades

@MainActor
final class DeckListViewModelTests: BaseTestCase {

    private var sut: DeckListViewModel!

    override init() async throws {
        try await super.init()
        sut = DeckListViewModel(dependencyContainer: testContainer.container)
    }

    isolated deinit {
        sut = nil
    }

    private func makeDeck(name: String, cards: [CardDTO] = []) -> DeckDTO {
        let deck = DeckDTO()
        deck.name = name
        deck.list = cards
        return deck
    }

    // MARK: - Load

    @Test
    func loadDecks_populatesItemsSortedByName() async {
        try? await populateTestData(objects: [
            makeDeck(name: "Zeta"),
            makeDeck(name: "Alpha")
        ])

        await sut.loadDecks()

        #expect(sut.items.map(\.name) == ["Alpha", "Zeta"])
        #expect(sut.isLoading == false)
    }

    @Test
    func loadDecks_computesCardCounts() async {
        let deck = makeDeck(name: "Counted", cards: [
            CardDTO.stub(code: "01001", quantity: 2),
            CardDTO.stub(code: "01002", quantity: 3)
        ])
        try? await populateTestData(objects: [deck])

        await sut.loadDecks()

        #expect(sut.items.first(where: { $0.id == deck.id })?.cardCount == 5)
    }

    // MARK: - Filtering

    @Test
    func filterItems_byName() {
        let alpha = makeDeck(name: "Alpha Strike")
        let beta = makeDeck(name: "Beta Build")
        sut.updateItems([DeckListItem(deck: alpha), DeckListItem(deck: beta)])

        sut.performFiltering(searchText: "Alpha")

        #expect(sut.filteredItems.map(\.name) == ["Alpha Strike"])
    }

    // MARK: - Delete

    @Test
    func delete_removesDeck() async throws {
        let keep = makeDeck(name: "Keep")
        let remove = makeDeck(name: "Remove")
        try? await populateTestData(objects: [keep, remove])
        await sut.loadDecks()
        let item = try #require(sut.items.first(where: { $0.id == remove.id }))

        await sut.delete(item)

        #expect(sut.items.map(\.name) == ["Keep"])
    }

    // MARK: - Rename

    @Test
    func renameDeck_replacesListItemSnapshotWithUpdatedName() async throws {
        let deck = makeDeck(name: "Old Name")
        try? await populateTestData(objects: [deck])
        await sut.loadDecks()
        let originalItem = try #require(sut.items.first)

        await confirmation("Deck list invalidated after rename") { confirm in
            withObservationTracking {
                _ = sut.filteredItems.map(\.name)
            } onChange: {
                confirm()
            }

            await sut.renameDeck(originalItem, newName: "New Name")
        }

        #expect(originalItem.name == "Old Name")
        #expect(sut.items.map(\.name) == ["New Name"])
    }

    @Test
    func renameDeck_blankName_isNoOp() async throws {
        let deck = makeDeck(name: "Original")
        try? await populateTestData(objects: [deck])
        await sut.loadDecks()
        let item = try #require(sut.items.first)

        await sut.renameDeck(item, newName: "   ")

        #expect(sut.items.map(\.name) == ["Original"])
    }
}
