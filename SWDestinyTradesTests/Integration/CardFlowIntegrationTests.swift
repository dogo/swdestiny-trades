//
//  CardFlowIntegrationTests.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

@testable import SWDestinyTrades
import XCTest

@MainActor
final class CardFlowIntegrationTests: BaseTestCase {

    func testMultipleViewsShareSameTestContainer() async throws {
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

        let cardListView = helper.createView {
            CardListView(set: set)
        }

        let cardDetailView = helper.createView {
            CardDetailView(cards: [card1], selectedCard: card1)
        }

        XCTAssertNotNil(cardListView)
        XCTAssertNotNil(cardDetailView)
    }

    func testDataFlowBetweenViewModelsThroughSharedDatabase() async throws {
        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Initial Name"
        card.setCode = "AW"
        try await populateTestData(objects: [card])

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)

        await viewModel1.loadCards()

        XCTAssertEqual(viewModel1.items.count, 1)
        XCTAssertEqual(viewModel1.items.first?.name, "Initial Name")

        try await testDatabase.update {
            card.name = "Updated Name"
        }

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCards()

        XCTAssertEqual(viewModel2.items.count, 1)
        XCTAssertEqual(viewModel2.items.first?.name, "Updated Name")
    }

    func testNavigationFlowWithMockCoordinator() async throws {
        let navMock = NavigationCoordinatorMock()
        let helper = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: navMock)

        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Test Card"
        card.setCode = "AW"
        try await populateTestData(objects: [card])

        let view = helper.createView {
            CardListView(set: set)
        }

        let viewModel = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel.loadCards()

        XCTAssertEqual(viewModel.items.count, 1)

        navMock.navigate(to: .cardDetail(viewModel.items, card))

        XCTAssertTrue(navMock.didNavigate(to: .cardDetail(viewModel.items, card)))
        XCTAssertEqual(navMock.navigationCallCount(to: .cardDetail(viewModel.items, card)), 1)

        XCTAssertNotNil(view)
    }

    func testFullFeatureFlowWithSharedContainer() async throws {
        let navMock = NavigationCoordinatorMock()
        let helper = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: navMock)

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

        let listViewModel = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await listViewModel.loadCards()

        XCTAssertEqual(listViewModel.items.count, 2)
        XCTAssertFalse(listViewModel.isLoading)

        let selectedCard = listViewModel.items.first!
        navMock.navigate(to: .cardDetail(listViewModel.items, selectedCard))

        XCTAssertTrue(navMock.didNavigate(to: .cardDetail(listViewModel.items, selectedCard)))

        let detailView = helper.createView {
            CardDetailView(cards: [selectedCard], selectedCard: selectedCard)
        }

        XCTAssertNotNil(detailView)

        let deck = DeckDTO()
        deck.name = "Test Deck"
        try await populateTestData(objects: [deck])

        let decks: [DeckDTO] = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)
        XCTAssertEqual(decks.count, 1)
        XCTAssertEqual(decks.first?.name, "Test Deck")
    }
}
