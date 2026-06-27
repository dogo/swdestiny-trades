//
//  DeckBuilderViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class DeckBuilderViewModelTests: BaseTestCase {

    private func makeDeck(name: String = "Test Deck", cards: [CardDTO] = []) -> DeckDTO {
        let deck = DeckDTO()
        deck.name = name
        deck.list = cards
        return deck
    }

    private func makeSUT(deck: DeckDTO?) -> DeckBuilderViewModel {
        DeckBuilderViewModel(deck: deck, dependencyContainer: testContainer.container)
    }

    // MARK: - Initialization

    @Test
    func test_init_withoutDeck_createsNewEmptyDeck() {
        let sut = DeckBuilderViewModel(dependencyContainer: testContainer.container)

        #expect(sut.isNewDeck)
        #expect(sut.deck.name == "New Deck")
        #expect(sut.isDeckEmpty)
        #expect(sut.deckSections.isEmpty)
    }

    @Test
    func test_init_withExistingDeck_isNotNew() {
        let sut = makeSUT(deck: makeDeck(cards: [CardDTO.stub(code: "01001")]))

        #expect(sut.isNewDeck == false)
        #expect(sut.isDeckEmpty == false)
    }

    // MARK: - Counts

    @Test
    func test_counts_reflectDeckList() {
        let sut = makeSUT(deck: makeDeck(cards: [
            CardDTO.stub(code: "01001", quantity: 2),
            CardDTO.stub(code: "01002", quantity: 3)
        ]))

        #expect(sut.totalCardCount == 5)
        #expect(sut.uniqueCardCount == 2)
        #expect(sut.isDeckEmpty == false)
    }

    // MARK: - Sections

    @Test
    func test_loadDeckData_buildsSectionsCoveringAllCards() {
        let sut = makeSUT(deck: makeDeck(cards: [
            CardDTO.stub(code: "01001", name: "Captain Phasma"),
            CardDTO.stub(code: "01002", name: "Kylo Ren")
        ]))

        let sectionedCodes = sut.deckSections.flatMap { $0.cards.map(\.code) }.sorted()
        #expect(sut.deckSections.isEmpty == false)
        #expect(sectionedCodes == ["01001", "01002"])
    }

    @Test
    func test_toggleSection_flipsCollapsedState() throws {
        let sut = makeSUT(deck: makeDeck(cards: [CardDTO.stub(code: "01001")]))
        let section = try #require(sut.deckSections.first)
        let original = section.isCollapsed

        sut.toggleSection(section)

        #expect(sut.deckSections.first?.isCollapsed == !original)
    }

    // MARK: - Share text

    @Test
    func test_prepareShareText_includesDeckAndCardNames() {
        let sut = makeSUT(deck: makeDeck(name: "My Deck", cards: [
            CardDTO.stub(code: "01001", name: "Captain Phasma")
        ]))

        sut.prepareShareText()

        let text = sut.shareText ?? ""
        #expect(text.contains("My Deck"))
        #expect(text.contains("Captain Phasma"))
    }

    // MARK: - Save

    @Test
    func test_saveDeck_persistsAndClearsNewFlag() async {
        let sut = makeSUT(deck: nil)
        sut.deck.list = [CardDTO.stub(code: "01001")]

        await sut.saveDeck()

        let decks = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)
        #expect(decks.count == 1)
        #expect(sut.isNewDeck == false)
    }

    @Test
    func test_saveDeck_whenSaveFails_enqueuesErrorToast() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        let sut = makeSUT(deck: makeDeck(cards: [CardDTO.stub(code: "01001")]))

        await sut.saveDeck()

        #expect(sut.toastQueue.current?.type == .error)
    }

    @Test
    func test_handleViewAppear_newDeckWithCards_persistsAndClearsNewFlag() async {
        let sut = makeSUT(deck: nil)
        sut.deck.list = [CardDTO.stub(code: "01001")]

        await sut.handleViewAppear()

        let decks = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)
        #expect(decks.count == 1)
        #expect(sut.isNewDeck == false)
    }

    // MARK: - Mutations (async Task)

    @Test
    func test_removeCard_removesFromDeckAndReorganizes() async {
        let card1 = CardDTO.stub(code: "01001")
        let card2 = CardDTO.stub(code: "01002")
        let sut = makeSUT(deck: makeDeck(cards: [card1, card2]))

        sut.removeCard(card1)
        await waitUntil { sut.deck.list.count == 1 }

        #expect(sut.deck.list.map(\.code) == ["01002"])
        #expect(sut.uniqueCardCount == 1)
    }

    @Test
    func test_updateCardQuantity_updatesCountAndReorganizes() async {
        let card = CardDTO.stub(code: "01001", quantity: 1)
        let sut = makeSUT(deck: makeDeck(cards: [card]))

        sut.updateCardQuantity(card, quantity: 4)
        await waitUntil { sut.totalCardCount == 4 }

        #expect(sut.totalCardCount == 4)
    }

    @Test
    func test_updateCharacterElite_persistsEliteFlag() async {
        let card = CardDTO.stub(code: "01001", isElite: false)
        let sut = makeSUT(deck: makeDeck(cards: [card]))

        sut.updateCharacterElite(card, isElite: true)
        await waitUntil { card.isElite }

        #expect(card.isElite)
    }
}
