//
//  AddToDeckViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class AddToDeckViewModelTests: BaseTestCase {

    private var deck: DeckDTO!
    private var sut: AddToDeckViewModel!

    override func setUp() async throws {
        try await super.setUp()
        deck = DeckDTO()
        deck.name = "Test Deck"
        sut = AddToDeckViewModel(deck: deck, dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        deck = nil
        try await super.tearDown()
    }

    // MARK: - Filtering

    func test_filterItems_emptySearch_returnsAll() {
        sut.updateItems([CardDTO.stub(code: "01001"), CardDTO.stub(code: "01002")])

        XCTAssertEqual(sut.filterItems(searchText: "").count, 2)
    }

    func test_filterItems_matchesNameSubtitleTypeAndSet() {
        let phasma = CardDTO.stub(setCode: "AW", typeCode: "character", code: "01001", name: "Captain Phasma", subtitle: "Elite Trooper")
        let saber = CardDTO.stub(setCode: "SOR", typeCode: "upgrade", code: "02002", name: "Lightsaber", subtitle: "Weapon")
        sut.updateItems([phasma, saber])

        XCTAssertEqual(sut.filterItems(searchText: "Phasma").map(\.code), ["01001"])
        XCTAssertEqual(sut.filterItems(searchText: "Weapon").map(\.code), ["02002"])
        XCTAssertEqual(sut.filterItems(searchText: "upgrade").map(\.code), ["02002"])
        XCTAssertEqual(sut.filterItems(searchText: "AW").map(\.code), ["01001"])
    }

    // MARK: - Loading

    func test_loadRemoteCards_populatesItemsFromService() async {
        mockSWDestinyService.retrieveAllCardsResult = [
            CardDTO.stub(code: "01001"),
            CardDTO.stub(code: "01002")
        ]

        sut.loadRemoteCards()
        await sut.awaitCurrentLoad()

        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.dataSource, .remote)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadRemoteCards_onError_enqueuesErrorToast() async {
        mockSWDestinyService.retrieveAllCardsError = APIError.invalidData

        sut.loadRemoteCards()
        await sut.awaitCurrentLoad()

        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    func test_loadLocalCards_populatesFromUserCollection() async {
        let collection = UserCollectionDTO.stub(collection: [
            CardDTO.stub(code: "01001"),
            CardDTO.stub(code: "01002")
        ])
        try? await populateTestData(objects: [collection])

        sut.loadLocalCards()
        await sut.awaitCurrentLoad()

        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.dataSource, .local)
    }

    func test_loadLocalCards_noCollection_loadsEmpty() async {
        sut.loadLocalCards()
        await sut.awaitCurrentLoad()

        XCTAssertTrue(sut.items.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Add card

    func test_addCardToDeck_appendsCopyAndShowsSuccess() async {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")

        sut.addCardToDeck(card)
        await waitUntil { self.sut.toastQueue.current != nil }

        XCTAssertEqual(deck.list.map(\.code), ["01001"])
        XCTAssertEqual(deck.list.first?.quantity, 1)
        XCTAssertNotEqual(deck.list.first?.id, card.id) // a fresh copy
        XCTAssertEqual(sut.toastQueue.current?.type, .success)
    }

    func test_addCardToDeck_duplicateCode_showsInfoAndDoesNotAppend() {
        deck.list = [CardDTO.stub(code: "01001")]

        sut.addCardToDeck(CardDTO.stub(code: "01001"))

        XCTAssertEqual(deck.list.count, 1)
        XCTAssertEqual(sut.toastQueue.current?.type, .info)
    }

    // MARK: - Helpers

    private func waitUntil(timeout: TimeInterval = 2.0, _ condition: @MainActor () -> Bool) async {
        let start = Date()
        while !condition() {
            if Date().timeIntervalSince(start) >= timeout { return }
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        }
    }
}
