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
        registerMock(AuthServiceProtocol.self) { AuthServiceMock() }
        registerMock(DeckServiceProtocol.self) { DeckServiceMock() }
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

    // MARK: - Remote

    @Test
    func resolvedDeck_remote_loadsFullCards() async throws {
        let authService = AuthServiceMock()
        authService.isLoggedIn = true
        let deckService = DeckServiceMock()
        deckService.decks = [RemoteDeckDTO.stub(slots: ["05117": 2]).deck]
        registerMock(AuthServiceProtocol.self) { authService }
        registerMock(DeckServiceProtocol.self) { deckService }
        mockCardService.retrieveCardResult = CardDTO.stub(code: "05117")
        await sut.loadDecks()

        let item = try #require(sut.items.first { $0.id == "arh-1" })
        #expect(item.isRemote)
        let deck = try #require(await sut.resolvedDeck(for: item))

        #expect(deck.list.map(\.code) == ["05117"])
        #expect(deck.list.map(\.quantity) == [2])
        #expect(mockCardService.retrieveAllCardsCallCount == 0)
        #expect(sut.loadingDeckID == nil)
    }

    @Test
    func loadDecks_remoteFailure_keepsLocalDecksAndShowsToast() async throws {
        try await populateTestData(objects: [makeDeck(name: "Local")])
        let authService = AuthServiceMock()
        authService.isLoggedIn = true
        let deckService = DeckServiceMock()
        deckService.error = APIError.serverError
        registerMock(AuthServiceProtocol.self) { authService }
        registerMock(DeckServiceProtocol.self) { deckService }

        await sut.loadDecks()

        #expect(sut.items.map(\.name) == ["Local"])
        #expect(sut.loadingState.isLoaded)
        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func loadDecks_remoteCancelled_showsNoToast() async {
        let authService = AuthServiceMock()
        authService.isLoggedIn = true
        let deckService = DeckServiceMock()
        deckService.error = CancellationError()
        registerMock(AuthServiceProtocol.self) { authService }
        registerMock(DeckServiceProtocol.self) { deckService }

        await sut.loadDecks()

        #expect(sut.toastQueue.current == nil)
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

    @Test
    func delete_remoteDeck_deletesOnServerAndDropsFromList() async throws {
        let authService = AuthServiceMock()
        authService.isLoggedIn = true
        let deckService = DeckServiceMock()
        deckService.decks = [RemoteDeckDTO.stub().deck]
        registerMock(AuthServiceProtocol.self) { authService }
        registerMock(DeckServiceProtocol.self) { deckService }
        let local = makeDeck(name: "Local")
        try? await populateTestData(objects: [local])
        await sut.loadDecks()
        let item = try #require(sut.items.first { $0.id == "arh-1" })

        await sut.delete(item)

        #expect(deckService.deletedRemoteIDs == [1])
        #expect(sut.items.map(\.name) == ["Local"])
    }

    @Test
    func delete_remoteDeckFails_keepsItAndShowsError() async throws {
        let authService = AuthServiceMock()
        authService.isLoggedIn = true
        let deckService = DeckServiceMock()
        deckService.decks = [RemoteDeckDTO.stub().deck]
        registerMock(AuthServiceProtocol.self) { authService }
        registerMock(DeckServiceProtocol.self) { deckService }
        await sut.loadDecks()
        let item = try #require(sut.items.first { $0.id == "arh-1" })
        deckService.error = APIError.serverError

        await sut.delete(item)

        #expect(sut.items.map(\.id) == ["arh-1"])
        #expect(sut.toastQueue.current?.type == .error)
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
