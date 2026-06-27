//
//  DeckBuilderViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

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

    func test_init_withoutDeck_createsNewEmptyDeck() {
        let sut = DeckBuilderViewModel(dependencyContainer: testContainer.container)

        XCTAssertTrue(sut.isNewDeck)
        XCTAssertEqual(sut.deck.name, "New Deck")
        XCTAssertTrue(sut.isDeckEmpty)
        XCTAssertTrue(sut.deckSections.isEmpty)
    }

    func test_init_withExistingDeck_isNotNew() {
        let sut = makeSUT(deck: makeDeck(cards: [CardDTO.stub(code: "01001")]))

        XCTAssertFalse(sut.isNewDeck)
        XCTAssertFalse(sut.isDeckEmpty)
    }

    // MARK: - Counts

    func test_counts_reflectDeckList() {
        let sut = makeSUT(deck: makeDeck(cards: [
            CardDTO.stub(code: "01001", quantity: 2),
            CardDTO.stub(code: "01002", quantity: 3)
        ]))

        XCTAssertEqual(sut.totalCardCount, 5)
        XCTAssertEqual(sut.uniqueCardCount, 2)
        XCTAssertFalse(sut.isDeckEmpty)
    }

    // MARK: - Sections

    func test_loadDeckData_buildsSectionsCoveringAllCards() {
        let sut = makeSUT(deck: makeDeck(cards: [
            CardDTO.stub(code: "01001", name: "Captain Phasma"),
            CardDTO.stub(code: "01002", name: "Kylo Ren")
        ]))

        let sectionedCodes = sut.deckSections.flatMap { $0.cards.map(\.code) }.sorted()
        XCTAssertFalse(sut.deckSections.isEmpty)
        XCTAssertEqual(sectionedCodes, ["01001", "01002"])
    }

    func test_toggleSection_flipsCollapsedState() {
        let sut = makeSUT(deck: makeDeck(cards: [CardDTO.stub(code: "01001")]))
        let section = try? XCTUnwrap(sut.deckSections.first)
        let original = section!.isCollapsed

        sut.toggleSection(section!)

        XCTAssertEqual(sut.deckSections.first?.isCollapsed, !original)
    }

    // MARK: - Share text

    func test_prepareShareText_includesDeckAndCardNames() {
        let sut = makeSUT(deck: makeDeck(name: "My Deck", cards: [
            CardDTO.stub(code: "01001", name: "Captain Phasma")
        ]))

        sut.prepareShareText()

        let text = sut.shareText ?? ""
        XCTAssertTrue(text.contains("My Deck"))
        XCTAssertTrue(text.contains("Captain Phasma"))
    }

    // MARK: - Save

    func test_saveDeck_persistsAndClearsNewFlag() async {
        let sut = makeSUT(deck: nil)
        sut.deck.list = [CardDTO.stub(code: "01001")]

        await sut.saveDeck()

        let decks = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(decks.count, 1)
        XCTAssertFalse(sut.isNewDeck)
    }

    func test_saveDeck_whenSaveFails_enqueuesErrorToast() async {
        testDatabase.stubbedSaveError = DatabaseError.invalidObject
        let sut = makeSUT(deck: makeDeck(cards: [CardDTO.stub(code: "01001")]))

        await sut.saveDeck()

        XCTAssertEqual(sut.toastQueue.current?.type, .error)
    }

    func test_handleViewAppear_newDeckWithCards_persistsAndClearsNewFlag() async {
        let sut = makeSUT(deck: nil)
        sut.deck.list = [CardDTO.stub(code: "01001")]

        await sut.handleViewAppear()

        let decks = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(decks.count, 1)
        XCTAssertFalse(sut.isNewDeck)
    }

    // MARK: - Mutations (async Task)

    func test_removeCard_removesFromDeckAndReorganizes() async {
        let card1 = CardDTO.stub(code: "01001")
        let card2 = CardDTO.stub(code: "01002")
        let sut = makeSUT(deck: makeDeck(cards: [card1, card2]))

        sut.removeCard(card1)
        await waitUntil { sut.deck.list.count == 1 }

        XCTAssertEqual(sut.deck.list.map(\.code), ["01002"])
        XCTAssertEqual(sut.uniqueCardCount, 1)
    }

    func test_updateCardQuantity_updatesCountAndReorganizes() async {
        let card = CardDTO.stub(code: "01001", quantity: 1)
        let sut = makeSUT(deck: makeDeck(cards: [card]))

        sut.updateCardQuantity(card, quantity: 4)
        await waitUntil { sut.totalCardCount == 4 }

        XCTAssertEqual(sut.totalCardCount, 4)
    }

    func test_updateCharacterElite_persistsEliteFlag() async {
        let card = CardDTO.stub(code: "01001", isElite: false)
        let sut = makeSUT(deck: makeDeck(cards: [card]))

        sut.updateCharacterElite(card, isElite: true)
        await waitUntil { card.isElite }

        XCTAssertTrue(card.isElite)
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
