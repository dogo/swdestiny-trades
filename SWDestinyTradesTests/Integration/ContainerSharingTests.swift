//
//  ContainerSharingTests.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class ContainerSharingTests: BaseTestCase {

    func testTestContainerCanBeSharedAcrossMultipleViewCreations() async throws {
        let helper = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: nil)

        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Test Card"
        card.setCode = "AW"
        try await populateTestData(objects: [card])

        let view1 = helper.createView {
            CardListView(set: set)
        }

        let view2 = helper.createView {
            CardDetailView(cards: [card], selectedCard: card)
        }

        let view3 = helper.createView {
            CardListView(set: set)
        }

        XCTAssertNotNil(view1)
        XCTAssertNotNil(view2)
        XCTAssertNotNil(view3)
    }

    func testDatabaseChangesAreVisibleAcrossViews() async throws {
        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Original Name"
        card.setCode = "AW"
        try await populateTestData(objects: [card])

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel1.loadCardsAsync()

        XCTAssertEqual(viewModel1.items.count, 1)
        XCTAssertEqual(viewModel1.items.first?.name, "Original Name")

        card.name = "Modified Name"
        try await testDatabase.save(object: card, update: .all)

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCardsAsync()

        XCTAssertEqual(viewModel2.items.count, 1)
        XCTAssertEqual(viewModel2.items.first?.name, "Modified Name")

        let fetchedCards: [CardDTO] = await testDatabase.fetch(CardDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(fetchedCards.count, 1)
        XCTAssertEqual(fetchedCards.first?.name, "Modified Name")
    }

    func testNoAdditionalCodeNeededForIntegrationTests() async throws {
        let helper = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: nil)

        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card1 = CardDTO()
        card1.code = "card1"
        card1.name = "Card One"
        card1.setCode = "AW"

        let card2 = CardDTO()
        card2.code = "card2"
        card2.name = "Card Two"
        card2.setCode = "AW"

        try await populateTestData(objects: [card1, card2])

        let viewModel = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel.loadCardsAsync()

        XCTAssertEqual(viewModel.items.count, 2)

        let view = helper.createView {
            CardListView(set: set)
        }

        XCTAssertNotNil(view)
    }

    func testMultipleViewModelsShareSameDatabaseData() async throws {
        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card1 = CardDTO()
        card1.code = "card1"
        card1.name = "Card One"
        card1.setCode = "AW"

        let card2 = CardDTO()
        card2.code = "card2"
        card2.name = "Card Two"
        card2.setCode = "AW"

        try await populateTestData(objects: [card1, card2])

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel1.loadCardsAsync()

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCardsAsync()

        XCTAssertEqual(viewModel1.items.count, 2)
        XCTAssertEqual(viewModel2.items.count, 2)

        XCTAssertEqual(viewModel1.items.first?.name, viewModel2.items.first?.name)
        XCTAssertEqual(viewModel1.items.last?.name, viewModel2.items.last?.name)
    }

    func testDatabaseDataPersistsAcrossMultipleOperations() async throws {
        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Initial"
        card.setCode = "AW"
        try await populateTestData(objects: [card])

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel1.loadCardsAsync()
        XCTAssertEqual(viewModel1.items.count, 1)
        XCTAssertEqual(viewModel1.items.first?.name, "Initial")

        card.name = "Updated Once"
        try await testDatabase.save(object: card, update: .all)

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCardsAsync()
        XCTAssertEqual(viewModel2.items.first?.name, "Updated Once")

        card.name = "Updated Twice"
        try await testDatabase.save(object: card, update: .all)

        let viewModel3 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel3.loadCardsAsync()
        XCTAssertEqual(viewModel3.items.first?.name, "Updated Twice")
    }

    func testContainerSharingWithDifferentViewTypes() async throws {
        let helper = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: nil)

        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Test Card"
        card.setCode = "AW"
        try await populateTestData(objects: [card])

        let deck = DeckDTO()
        deck.name = "Test Deck"
        try await populateTestData(objects: [deck])

        let cardListView = helper.createView {
            CardListView(set: set)
        }

        let cardDetailView = helper.createView {
            CardDetailView(cards: [card], selectedCard: card)
        }

        XCTAssertNotNil(cardListView)
        XCTAssertNotNil(cardDetailView)

        let fetchedCards: [CardDTO] = await testDatabase.fetch(CardDTO.self, predicate: nil, sorted: nil)
        let fetchedDecks: [DeckDTO] = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)

        XCTAssertEqual(fetchedCards.count, 1)
        XCTAssertEqual(fetchedDecks.count, 1)
    }
}
