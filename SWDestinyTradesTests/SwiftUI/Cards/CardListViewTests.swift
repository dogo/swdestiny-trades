//
//  CardListViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI
import XCTest

@testable import SWDestinyTrades

@MainActor
final class CardListViewTests: BaseTestCase {

    var helper: ViewTestHelper!
    var testSet: SetDTO!

    override func setUp() async throws {
        try await super.setUp()

        helper = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: nil)

        testSet = SetDTO.stub(name: "Awakenings", code: "AW")
    }

    override func tearDown() async throws {
        helper = nil
        testSet = nil
        try await super.tearDown()
    }

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

        let view = helper.createView {
            CardListView(set: testSet)
        }

        XCTAssertNotNil(view)
    }

    func testViewUsesTestContainer() async throws {
        let card = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Test Card"
        )

        try await populateTestData(objects: [card])

        let viewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)

        viewModel.loadCards()

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.code, "01001")
    }

    func testViewWithNavigationCoordinatorMock() async throws {
        let navMock = NavigationCoordinatorMock()
        let helperWithMock = ViewTestHelper(testContainer: testContainer, navigationCoordinatorMock: navMock)

        let card = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Test Card"
        )

        try await populateTestData(objects: [card])

        let view = helperWithMock.createView {
            CardListView(set: testSet)
        }

        XCTAssertNotNil(view)
        XCTAssertNotNil(helperWithMock.navigationCoordinatorMock)
    }

    func testViewEnvironmentInjection() async throws {
        let view = helper.createView {
            CardListView(set: testSet)
        }

        XCTAssertNotNil(view)
        XCTAssertNotNil(helper.container)
        XCTAssertNotNil(helper.navigationCoordinator)
        XCTAssertNotNil(helper.appState)
    }

    func testViewModelCreatedThroughTestContainer() async throws {
        let viewModel = helper.createViewModel(CardListViewModel.self)

        XCTAssertNotNil(viewModel.dependencyContainer)
    }

    func testViewWithEmptyDatabase() async throws {
        let view = helper.createView {
            CardListView(set: testSet)
        }

        XCTAssertNotNil(view)
    }

    func testViewWithMultipleCards() async throws {
        let cards = (1 ... 5).map { index in
            CardDTO.stub(
                setCode: "AW",
                code: "0100\(index)",
                name: "Card \(index)",
                subtitle: "Subtitle \(index)"
            )
        }

        try await populateTestData(objects: cards)

        let viewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)

        viewModel.loadCards()

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.items.count, 5)
    }

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

        XCTAssertEqual(fetchedCards.count, 1)
        XCTAssertEqual(fetchedCards.first?.name, "Test Card")
    }

    func testViewWithDifferentSets() async throws {
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

        try await populateTestData(objects: [awCard, sorCard])

        let awViewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)
        awViewModel.loadCards()

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(awViewModel.items.count, 1)
        XCTAssertEqual(awViewModel.items.first?.setCode, "AW")

        let sorSet = SetDTO.stub(name: "Spirit of Rebellion", code: "SOR")
        let sorViewModel = CardListViewModel(set: sorSet, dependencyContainer: testContainer.container)
        sorViewModel.loadCards()

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sorViewModel.items.count, 1)
        XCTAssertEqual(sorViewModel.items.first?.setCode, "SOR")
    }

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

        XCTAssertEqual(fetchedCards.count, 3)
    }

    func testViewWithAppState() async throws {
        let view = helper.createView {
            CardListView(set: testSet)
        }

        XCTAssertNotNil(view)
        XCTAssertNotNil(helper.appState)
    }

    func testViewCreationWithCustomViewModel() async throws {
        let card = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Test Card"
        )

        try await populateTestData(objects: [card])

        let customViewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)

        let view = helper.createView {
            CardListView(set: testSet, viewModel: customViewModel)
        }

        XCTAssertNotNil(view)
    }
}
