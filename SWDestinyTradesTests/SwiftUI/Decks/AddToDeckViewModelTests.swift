//
//  AddToDeckViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class AddToDeckViewModelTests: BaseTestCase {

    private var deck: DeckDTO!
    private var sut: AddToDeckViewModel!

    override init() async throws {
        try await super.init()
        deck = DeckDTO()
        deck.name = "Test Deck"
        sut = AddToDeckViewModel(deck: deck, dependencyContainer: testContainer.container)
    }

    isolated deinit {
        sut = nil
        deck = nil
    }

    // MARK: - Filtering

    @Test
    func filterItems_emptySearch_returnsAll() {
        sut.updateItems([CardDTO.stub(code: "01001"), CardDTO.stub(code: "01002")])

        #expect(sut.filterItems(searchText: "").count == 2)
    }

    @Test
    func filterItems_matchesNameSubtitleTypeAndSet() {
        let phasma = CardDTO.stub(setCode: "AW", typeCode: "character", code: "01001", name: "Captain Phasma", subtitle: "Elite Trooper")
        let saber = CardDTO.stub(setCode: "SOR", typeCode: "upgrade", code: "02002", name: "Lightsaber", subtitle: "Weapon")
        sut.updateItems([phasma, saber])

        #expect(sut.filterItems(searchText: "Phasma").map(\.code) == ["01001"])
        #expect(sut.filterItems(searchText: "Weapon").map(\.code) == ["02002"])
        #expect(sut.filterItems(searchText: "upgrade").map(\.code) == ["02002"])
        #expect(sut.filterItems(searchText: "AW").map(\.code) == ["01001"])
    }

    // MARK: - Loading

    @Test
    func loadRemoteCards_populatesItemsFromService() async {
        mockSWDestinyService.retrieveAllCardsResult = [
            CardDTO.stub(code: "01001"),
            CardDTO.stub(code: "01002")
        ]

        sut.loadRemoteCards()
        await sut.awaitCurrentLoad()

        #expect(sut.items.count == 2)
        #expect(sut.dataSource == .remote)
        #expect(sut.isLoading == false)
    }

    @Test
    func loadRemoteCards_onError_enqueuesErrorToast() async {
        mockSWDestinyService.retrieveAllCardsError = APIError.invalidData

        sut.loadRemoteCards()
        await sut.awaitCurrentLoad()

        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func loadLocalCards_populatesFromUserCollection() async {
        let collection = UserCollectionDTO.stub(collection: [
            CardDTO.stub(code: "01001"),
            CardDTO.stub(code: "01002")
        ])
        try? await populateTestData(objects: [collection])

        sut.loadLocalCards()
        await sut.awaitCurrentLoad()

        #expect(sut.items.count == 2)
        #expect(sut.dataSource == .local)
    }

    @Test
    func loadLocalCards_noCollection_loadsEmpty() async {
        sut.loadLocalCards()
        await sut.awaitCurrentLoad()

        #expect(sut.items.isEmpty)
        #expect(sut.isLoading == false)
    }

    // MARK: - Add card

    @Test
    func addCardToDeck_appendsCopyAndShowsSuccess() async {
        let card = CardDTO.stub(code: "01001", name: "Captain Phasma")

        sut.addCardToDeck(card)
        await waitUntil { self.sut.toastQueue.current != nil }

        #expect(deck.list.map(\.code) == ["01001"])
        #expect(deck.list.first?.quantity == 1)
        #expect(deck.list.first?.id != card.id) // a fresh copy
        #expect(sut.toastQueue.current?.type == .success)
    }

    @Test
    func addCardToDeck_duplicateCode_showsInfoAndDoesNotAppend() {
        deck.list = [CardDTO.stub(code: "01001")]

        sut.addCardToDeck(CardDTO.stub(code: "01001"))

        #expect(deck.list.count == 1)
        #expect(sut.toastQueue.current?.type == .info)
    }
}
