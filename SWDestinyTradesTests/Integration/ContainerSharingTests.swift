//
//  ContainerSharingTests.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

@MainActor
final class ContainerSharingTests: BaseTestCase {

    @Test
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

        _ = helper.createView {
            CardListView(set: set)
        }

        _ = helper.createView {
            CardDetailView(cards: [card], selectedCard: card)
        }

        _ = helper.createView {
            CardListView(set: set)
        }
    }

    @Test
    func testDatabaseChangesAreVisibleAcrossViews() async throws {
        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Original Name"
        card.setCode = "AW"

        mockSWDestinyService.retrieveSetCardListResult = [card]

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel1.loadCards()

        #expect(viewModel1.items.count == 1)
        #expect(viewModel1.items.first?.name == "Original Name")

        card.name = "Modified Name"
        mockSWDestinyService.retrieveSetCardListResult = [card]
        try await testDatabase.save(object: card, update: .all)

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCards()

        #expect(viewModel2.items.count == 1)
        #expect(viewModel2.items.first?.name == "Modified Name")

        let fetchedCards: [CardDTO] = await testDatabase.fetch(CardDTO.self, predicate: nil, sorted: nil)
        #expect(fetchedCards.count == 1)
        #expect(fetchedCards.first?.name == "Modified Name")
    }

    @Test
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

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        let viewModel = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel.loadCards()

        #expect(viewModel.items.count == 2)

        _ = helper.createView {
            CardListView(set: set)
        }
    }

    @Test
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

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel1.loadCards()

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCards()

        #expect(viewModel1.items.count == 2)
        #expect(viewModel2.items.count == 2)

        #expect(viewModel1.items.first?.name == viewModel2.items.first?.name)
        #expect(viewModel1.items.last?.name == viewModel2.items.last?.name)
    }

    @Test
    func testDatabaseDataPersistsAcrossMultipleOperations() async throws {
        let set = SetDTO()
        set.code = "AW"
        set.name = "Awakenings"
        try await populateTestData(objects: [set])

        let card = CardDTO()
        card.code = "card1"
        card.name = "Initial"
        card.setCode = "AW"

        mockSWDestinyService.retrieveSetCardListResult = [card]

        let viewModel1 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel1.loadCards()
        #expect(viewModel1.items.count == 1)
        #expect(viewModel1.items.first?.name == "Initial")

        card.name = "Updated Once"
        mockSWDestinyService.retrieveSetCardListResult = [card]
        try await testDatabase.save(object: card, update: .all)

        let viewModel2 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel2.loadCards()
        #expect(viewModel2.items.first?.name == "Updated Once")

        card.name = "Updated Twice"
        mockSWDestinyService.retrieveSetCardListResult = [card]
        try await testDatabase.save(object: card, update: .all)

        let viewModel3 = CardListViewModel(set: set, dependencyContainer: testContainer.container)
        await viewModel3.loadCards()
        #expect(viewModel3.items.first?.name == "Updated Twice")
    }

    @Test
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

        _ = helper.createView {
            CardListView(set: set)
        }

        _ = helper.createView {
            CardDetailView(cards: [card], selectedCard: card)
        }

        let fetchedCards: [CardDTO] = await testDatabase.fetch(CardDTO.self, predicate: nil, sorted: nil)
        let fetchedDecks: [DeckDTO] = await testDatabase.fetch(DeckDTO.self, predicate: nil, sorted: nil)

        #expect(fetchedCards.count == 1)
        #expect(fetchedDecks.count == 1)
    }
}
