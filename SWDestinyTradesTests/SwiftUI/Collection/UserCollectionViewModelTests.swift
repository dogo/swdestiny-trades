//
//  UserCollectionViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class UserCollectionViewModelTests: BaseTestCase {

    private var sut: UserCollectionViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = UserCollectionViewModel(dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Refresh

    func test_refreshCollection_populatesItemsFromCollection() async {
        let collection = UserCollectionDTO.stub(collection: [
            CardDTO.stub(code: "01001"),
            CardDTO.stub(code: "01002")
        ])
        try? await populateTestData(objects: [collection])

        await sut.refreshCollection()

        XCTAssertEqual(sut.items.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_refreshCollection_noCollection_isEmpty() async {
        await sut.refreshCollection()

        XCTAssertTrue(sut.items.isEmpty)
    }

    // MARK: - Filtering

    func test_filterItems_byColorTypeAndSearch_sortedByName() {
        let redCharacter = CardDTO.stub(typeCode: "character", factionCode: "red", code: "01001", name: "Zeb")
        let blueUpgrade = CardDTO.stub(typeCode: "upgrade", factionCode: "blue", code: "01002", name: "Anakin")
        sut.updateItems([redCharacter, blueUpgrade])

        sut.filter.selectedColors = ["red"]
        sut.applyFilters()

        XCTAssertEqual(sut.filteredItems.map(\.code), ["01001"])
    }

    func test_filterItems_emptyFilters_returnsAllSortedByName() {
        let zeb = CardDTO.stub(code: "01001", name: "Zeb")
        let anakin = CardDTO.stub(code: "01002", name: "Anakin")
        sut.updateItems([zeb, anakin])

        sut.applyFilters()

        XCTAssertEqual(sut.filteredItems.map(\.name), ["Anakin", "Zeb"])
    }

    func test_hasActiveFilters_reflectsFilterState() {
        XCTAssertFalse(sut.hasActiveFilters)

        sut.filter.selectedTypes = ["character"]

        XCTAssertTrue(sut.hasActiveFilters)
    }

    // MARK: - Share text

    func test_shareText_listsCardsWithPositiveQuantity() {
        sut.updateItems([
            CardDTO.stub(code: "01001", name: "Captain Phasma", quantity: 2),
            CardDTO.stub(code: "01002", name: "Zero", quantity: 0)
        ])
        sut.applyFilters()

        let text = sut.shareText
        XCTAssertTrue(text.contains("2x Captain Phasma"))
        XCTAssertFalse(text.contains("Zero"))
    }

    // MARK: - Update quantity

    func test_updateCardQuantity_persistsClampedQuantity() async {
        let card = CardDTO.stub(code: "01001", quantity: 1)
        try? await populateTestData(objects: [card])

        await sut.updateCardQuantity(card, quantity: -3)

        let stored = await testDatabase.fetchByKey(CardDTO.self, key: card.id)
        XCTAssertEqual(stored?.quantity, 0)
    }

    func test_updateCardQuantity_missingCard_enqueuesErrorToast() async {
        let card = CardDTO.stub(code: "09999")

        await sut.updateCardQuantity(card, quantity: 2)

        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    // MARK: - Remove card (async Task)

    func test_removeCard_removesFromStoredCollection() async {
        let card = CardDTO.stub(code: "01001")
        let collection = UserCollectionDTO.stub(collection: [card])
        try? await populateTestData(objects: [collection])

        sut.removeCard(card)
        await waitUntil { collection.myCollection.isEmpty }

        XCTAssertTrue(collection.myCollection.isEmpty)
    }

    // MARK: - Available sets (async Task)

    func test_loadAvailableSets_populatesSortedByName() async {
        try? await populateTestData(objects: [
            SetDTO.stub(name: "Spark of Hope", code: "SOH"),
            SetDTO.stub(name: "Awakenings", code: "AW")
        ])

        sut.loadAvailableSets()
        await waitUntil { self.sut.availableSets.count == 2 }

        XCTAssertEqual(sut.availableSets.map(\.name), ["Awakenings", "Spark of Hope"])
    }
}
