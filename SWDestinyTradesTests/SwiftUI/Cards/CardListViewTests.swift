//
//  CardListViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import Testing

@testable import SWDestinyTrades

@MainActor
final class CardListViewTests: BaseTestCase {

    var helper: ViewTestHelper!
    var testSet: SetDTO!

    override init() async throws {
        try await super.init()

        helper = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: nil)

        testSet = SetDTO.stub(name: "Awakenings", code: "AW")
    }

    deinit {
        helper = nil
        testSet = nil
    }

    @Test
    func testViewCreationWithTestData() async throws {
        let card1 = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Captain Phasma",
            subtitle: "Elite Trooper"
        )
        let card2 = CardDTO.stub(
            setCode: "AW",
            code: "01002",
            name: "Kylo Ren",
            subtitle: "Vader's Disciple"
        )

        try await populateTestData(objects: [card1, card2])

        _ = helper.createView {
            CardListView(set: testSet)
        }
    }

    @Test
    func testViewUsesTestContainer() async {
        let card = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Test Card"
        )

        mockSWDestinyService.retrieveSetCardListResult = [card]

        let viewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)

        await viewModel.loadCards()

        #expect(viewModel.items.count == 1)
        #expect(viewModel.items.first?.code == "01001")
    }

    @Test
    func testViewWithNavigationCoordinatorMock() async throws {
        let navMock = NavigationCoordinatorMock()
        let helperWithMock = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: navMock)

        let card = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Test Card"
        )

        try await populateTestData(objects: [card])

        _ = helperWithMock.createView {
            CardListView(set: testSet)
        }

        let storedMock = try #require(helperWithMock.navigationCoordinatorMock)
        #expect(storedMock === navMock)
    }

    @Test
    func testViewEnvironmentInjection() {
        _ = helper.createView {
            CardListView(set: testSet)
        }

        #expect(helper.navigationCoordinatorMock == nil)
    }

    @Test
    func testViewModelCreatedThroughTestContainer() {
        let viewModel = helper.createViewModel(CardListViewModel.self)

        #expect(viewModel.isLoading == false)
    }

    @Test
    func testViewWithEmptyDatabase() {
        _ = helper.createView {
            CardListView(set: testSet)
        }
    }

    @Test
    func testViewWithMultipleCards() async {
        let cards = (1 ... 5).map { index in
            CardDTO.stub(
                setCode: "AW",
                code: "0100\(index)",
                name: "Card \(index)",
                subtitle: "Subtitle \(index)"
            )
        }

        mockSWDestinyService.retrieveSetCardListResult = cards

        let viewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)

        await viewModel.loadCards()

        #expect(viewModel.items.count == 5)
    }

    @Test
    func testViewModelUsesDatabase() async throws {
        let card = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Test Card"
        )

        try await populateTestData(objects: [card])

        let database: DatabaseProtocol = testContainer.resolve(DatabaseProtocol.self)
        let fetchedCards: [CardDTO] = await database.fetch(
            CardDTO.self,
            predicate: NSPredicate(format: "code == %@", "01001"),
            sorted: nil
        )

        #expect(fetchedCards.count == 1)
        #expect(fetchedCards.first?.name == "Test Card")
    }

    @Test
    func testViewWithDifferentSets() async {
        let awCard = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Awakenings Card"
        )
        let sorCard = CardDTO.stub(
            setCode: "SOR",
            code: "02001",
            name: "Spirit of Rebellion Card"
        )

        mockSWDestinyService.retrieveSetCardListResult = [awCard]

        let awViewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)
        await awViewModel.loadCards()

        #expect(awViewModel.items.count == 1)
        #expect(awViewModel.items.first?.setCode == "AW")

        mockSWDestinyService.retrieveSetCardListResult = [sorCard]

        let sorSet = SetDTO.stub(name: "Spirit of Rebellion", code: "SOR")
        let sorViewModel = CardListViewModel(set: sorSet, dependencyContainer: testContainer.container)
        await sorViewModel.loadCards()

        #expect(sorViewModel.items.count == 1)
        #expect(sorViewModel.items.first?.setCode == "SOR")
    }

    @Test
    func testPopulateTestDataHelper() async throws {
        let cards = [
            CardDTO.stub(setCode: "AW", code: "01001", name: "Card 1"),
            CardDTO.stub(setCode: "AW", code: "01002", name: "Card 2"),
            CardDTO.stub(setCode: "AW", code: "01003", name: "Card 3")
        ]

        try await populateTestData(objects: cards)

        let database: DatabaseProtocol = testContainer.resolve(DatabaseProtocol.self)
        let fetchedCards: [CardDTO] = await database.fetch(
            CardDTO.self,
            predicate: NSPredicate(format: "setCode == %@", "AW"),
            sorted: nil
        )

        #expect(fetchedCards.count == 3)
    }

    @Test
    func testViewWithAppState() {
        _ = helper.createView {
            CardListView(set: testSet)
        }

        #expect(helper.navigationCoordinatorMock == nil)
    }

    @Test
    func testViewCreationWithCustomViewModel() async throws {
        let card = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Test Card"
        )

        try await populateTestData(objects: [card])

        let customViewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)

        _ = helper.createView {
            CardListView(set: testSet, viewModel: customViewModel)
        }
    }
}
