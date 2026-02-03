//
//  CardListViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/08/25.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class CardListViewModelTests: BaseTestCase {

    var sut: CardListViewModel!
    var testSet: SetDTO!

    override func setUp() async throws {
        try await super.setUp()
        testSet = SetDTO.stub(name: "Awakenings", code: "AW")
        sut = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)
    }

    override func tearDown() async throws {
        sut = nil
        testSet = nil
        try await super.tearDown()
    }

    func testLoadCardsFromDatabase() async throws {
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

        await sut.loadCardsAsync()

        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.items[0].code, "01001")
        XCTAssertEqual(sut.items[1].code, "01002")
        XCTAssertFalse(sut.isLoading)
    }

    func testLoadCardsWithEmptyDatabase() async throws {
        await sut.loadCardsAsync()

        XCTAssertEqual(sut.items.count, 0)
        XCTAssertFalse(sut.isLoading)
    }

    func testLoadCardsFiltersCorrectSet() async throws {
        let awCard = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Captain Phasma"
        )
        let sokCard = CardDTO.stub(
            setCode: "SOR",
            code: "02001",
            name: "Luke Skywalker"
        )

        try await populateTestData(objects: [awCard, sokCard])

        await sut.loadCardsAsync()

        XCTAssertEqual(sut.items.count, 1)
        XCTAssertEqual(sut.items[0].code, "01001")
        XCTAssertEqual(sut.items[0].setCode, "AW")
    }

    func testLoadCardsWithMockHttpClient() async throws {
        mockHttpClient.fileName = "card-list"
        mockHttpClient.error = false

        await sut.loadCardsAsync()

        XCTAssertFalse(sut.isLoading)
        XCTAssertGreaterThan(sut.items.count, 0, "Should have loaded cards from mock data")
    }

    func testLoadCardsHandlesHttpError() async throws {
        mockSWDestinyService.retrieveSetCardListError = APIError.invalidData

        await sut.loadCardsAsync()

        XCTAssertFalse(sut.isLoading)

        try await Task.sleep(nanoseconds: 150_000_000)

        XCTAssertTrue(sut.showToast)
        XCTAssertEqual(sut.toastType, .error)
    }

    func testAsyncOperationCompletesLoading() async throws {
        let card = CardDTO.stub(setCode: "AW", code: "01001")
        try await populateTestData(objects: [card])

        XCTAssertTrue(sut.isLoading)

        await sut.loadCardsAsync()

        XCTAssertFalse(sut.isLoading)
    }

    func testSearchFilteringByName() async throws {
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

        await sut.loadCardsAsync()

        sut.performFiltering(searchText: "Phasma")

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].name, "Captain Phasma")
    }

    func testSearchFilteringBySubtitle() async throws {
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

        await sut.loadCardsAsync()

        sut.performFiltering(searchText: "Vader")

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].name, "Kylo Ren")
    }

    func testColorFiltering() async throws {
        let redCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "red",
            code: "01001",
            name: "Captain Phasma"
        )
        let blueCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "blue",
            code: "01002",
            name: "Rey"
        )

        try await populateTestData(objects: [redCard, blueCard])

        await sut.loadCardsAsync()

        sut.filterOptions.selectedColors.insert("red")

        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].factionCode, "red")
    }

    func testTypeFiltering() async throws {
        let character = CardDTO.stub(
            setCode: "AW",
            typeCode: "character",
            code: "01001",
            name: "Captain Phasma"
        )
        let upgrade = CardDTO.stub(
            setCode: "AW",
            typeCode: "upgrade",
            code: "01002",
            name: "Lightsaber"
        )

        try await populateTestData(objects: [character, upgrade])

        await sut.loadCardsAsync()

        sut.filterOptions.selectedTypes.insert("character")

        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].typeCode, "character")
    }

    func testCostFiltering() async throws {
        let lowCostCard = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Card 1",
            cost: 1
        )
        let midCostCard = CardDTO.stub(
            setCode: "AW",
            code: "01002",
            name: "Card 2",
            cost: 3
        )
        let highCostCard = CardDTO.stub(
            setCode: "AW",
            code: "01003",
            name: "Card 3",
            cost: 5
        )

        try await populateTestData(objects: [lowCostCard, midCostCard, highCostCard])

        await sut.loadCardsAsync()

        sut.filterOptions.minCost = 2
        sut.filterOptions.maxCost = 4

        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].cost, 3)
    }

    func testPropertyLoadingAlwaysCompletes() async throws {
        for iteration in 0 ..< 100 {
            let randomCardCount = Int.random(in: 0 ... 10)
            var randomCards: [CardDTO] = []

            for index in 0 ..< randomCardCount {
                let card = CardDTO.stub(
                    setCode: "AW",
                    code: "test-\(iteration)-\(index)",
                    name: "Test Card \(iteration)-\(index)"
                )
                randomCards.append(card)
            }

            try await populateTestData(objects: randomCards)

            await sut.loadCardsAsync()

            XCTAssertFalse(sut.isLoading, "Loading should complete on iteration \(iteration)")
            XCTAssertEqual(sut.items.count, randomCardCount, "Should load correct number of cards on iteration \(iteration)")

            try await testDatabase.reset()
        }
    }
}
