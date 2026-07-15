//
//  CardFlowIntegrationTests.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

@testable import SWDestinyTrades
import Testing

@MainActor
final class CardFlowIntegrationTests: BaseTestCase {

    @Test
    func multipleViewsShareSameTestContainer() async throws {
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

        _ = helper.createView {
            CardListView(set: set)
        }

        _ = helper.createView {
            CardDetailView(cards: [card1], selectedCard: card1)
        }
    }

    @Test
    func dataFlowBetweenViewModelsThroughSharedDatabase() async throws {
        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Initial Name"
        card.setCode = "AW"

        mockSWDestinyService.retrieveSetCardListResult = [card]

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)

        await viewModel1.loadCards()

        #expect(viewModel1.items.count == 1)
        #expect(viewModel1.items.first?.name == "Initial Name")

        card.name = "Updated Name"
        mockSWDestinyService.retrieveSetCardListResult = [card]

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCards()

        #expect(viewModel2.items.count == 1)
        #expect(viewModel2.items.first?.name == "Updated Name")
    }

    @Test
    func navigationFlowWithMockCoordinator() async throws {
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

        mockSWDestinyService.retrieveSetCardListResult = [card]

        _ = helper.createView {
            CardListView(set: set)
        }

        let viewModel = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel.loadCards()

        #expect(viewModel.items.count == 1)

        navMock.navigate(to: .cardDetail(viewModel.items, card))

        #expect(navMock.didNavigate(to: .cardDetail(viewModel.items, card)))
        #expect(navMock.navigationCallCount(to: .cardDetail(viewModel.items, card)) == 1)
    }

    @Test
    func fullFeatureFlowWithSharedContainer() async throws {
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

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        let listViewModel = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await listViewModel.loadCards()

        #expect(listViewModel.items.count == 2)
        #expect(listViewModel.isLoading == false)

        let selectedCard = try #require(listViewModel.items.first)
        navMock.navigate(to: .cardDetail(listViewModel.items, selectedCard))

        #expect(navMock.didNavigate(to: .cardDetail(listViewModel.items, selectedCard)))

        _ = helper.createView {
            CardDetailView(cards: [selectedCard], selectedCard: selectedCard)
        }

        let deck = DeckDTO()
        deck.name = "Test Deck"
        try await populateTestData(objects: [deck])

        let decks: [DeckDTO] = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)
        #expect(decks.count == 1)
        #expect(decks.first?.name == "Test Deck")
    }
}
