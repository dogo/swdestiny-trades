//
//  UserCollectionViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class UserCollectionViewModelTests: BaseTestCase {

    private var sut: UserCollectionViewModel!

    override init() async throws {
        try await super.init()
        sut = UserCollectionViewModel(dependencyContainer: testContainer.container)
    }

    deinit {
        sut = nil
    }

    // MARK: - Refresh

    @Test
    func refreshCollection_populatesItemsFromCollection() async {
        let collection = UserCollectionDTO.stub(collection: [
            CardDTO.stub(code: "01001"),
            CardDTO.stub(code: "01002")
        ])
        try? await populateTestData(objects: [collection])

        await sut.refreshCollection()

        #expect(sut.items.count == 2)
        #expect(sut.isLoading == false)
    }

    @Test
    func refreshCollection_noCollection_isEmpty() async {
        await sut.refreshCollection()

        #expect(sut.items.isEmpty)
    }

    // MARK: - Filtering

    @Test
    func filterItems_byColorTypeAndSearch_sortedByName() {
        let redCharacter = CardDTO.stub(typeCode: "character", factionCode: "red", code: "01001", name: "Zeb")
        let blueUpgrade = CardDTO.stub(typeCode: "upgrade", factionCode: "blue", code: "01002", name: "Anakin")
        sut.updateItems([redCharacter, blueUpgrade])

        sut.filter.selectedColors = ["red"]
        sut.applyFilters()

        #expect(sut.filteredItems.map(\.code) == ["01001"])
    }

    @Test
    func filterItems_emptyFilters_returnsAllSortedByName() {
        let zeb = CardDTO.stub(code: "01001", name: "Zeb")
        let anakin = CardDTO.stub(code: "01002", name: "Anakin")
        sut.updateItems([zeb, anakin])

        sut.applyFilters()

        #expect(sut.filteredItems.map(\.name) == ["Anakin", "Zeb"])
    }

    @Test
    func hasActiveFilters_reflectsFilterState() {
        #expect(sut.hasActiveFilters == false)

        sut.filter.selectedTypes = ["character"]

        #expect(sut.hasActiveFilters)
    }

    // MARK: - Share text

    @Test
    func shareText_listsCardsWithPositiveQuantity() {
        sut.updateItems([
            CardDTO.stub(code: "01001", name: "Captain Phasma", quantity: 2),
            CardDTO.stub(code: "01002", name: "Zero", quantity: 0)
        ])
        sut.applyFilters()

        let text = sut.shareText
        #expect(text.contains("2x Captain Phasma"))
        #expect(text.contains("Zero") == false)
    }

    // MARK: - Update quantity

    @Test
    func updateCardQuantity_persistsClampedQuantity() async {
        let card = CardDTO.stub(code: "01001", quantity: 1)
        try? await populateTestData(objects: [card])

        await sut.updateCardQuantity(card, quantity: -3)

        let stored = await testDatabase.fetchByKey(CardDTO.self, key: card.id)
        #expect(stored?.quantity == 0)
    }

    @Test
    func updateCardQuantity_missingCard_enqueuesErrorToast() async {
        let card = CardDTO.stub(code: "09999")

        await sut.updateCardQuantity(card, quantity: 2)

        #expect(sut.toastQueue.current?.type == .error)
    }

    // MARK: - Remove card (async Task)

    @Test
    func removeCard_removesFromStoredCollection() async {
        let card = CardDTO.stub(code: "01001")
        let collection = UserCollectionDTO.stub(collection: [card])
        try? await populateTestData(objects: [collection])

        sut.removeCard(card)
        await waitUntil { collection.myCollection.isEmpty }

        #expect(collection.myCollection.isEmpty)
    }

    // MARK: - Available sets (async Task)

    @Test
    func loadAvailableSets_populatesSortedByName() async {
        try? await populateTestData(objects: [
            SetDTO.stub(name: "Spark of Hope", code: "SOH"),
            SetDTO.stub(name: "Awakenings", code: "AW")
        ])

        sut.loadAvailableSets()
        await waitUntil { self.sut.availableSets.count == 2 }

        #expect(sut.availableSets.map(\.name) == ["Awakenings", "Spark of Hope"])
    }
}
