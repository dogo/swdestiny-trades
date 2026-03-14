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

    // MARK: - Properties

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

    func testLoadCardsFromDatabase() async {
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

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        await sut.loadCards()

        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.items[0].code, "01001")
        XCTAssertEqual(sut.items[1].code, "01002")
        XCTAssertFalse(sut.isLoading)
    }

    func testLoadCardsWithEmptyDatabase() async {
        await sut.loadCards()

        XCTAssertEqual(sut.items.count, 0)
        XCTAssertFalse(sut.isLoading)
    }

    func testLoadCardsFiltersCorrectSet() async {
        let awCard = CardDTO.stub(
            setCode: "AW",
            code: "01001",
            name: "Captain Phasma"
        )

        mockSWDestinyService.retrieveSetCardListResult = [awCard]

        await sut.loadCards()

        XCTAssertEqual(sut.items.count, 1)
        XCTAssertEqual(sut.items[0].code, "01001")
        XCTAssertEqual(sut.items[0].setCode, "AW")
    }

    func testLoadCardsWithMockHttpClient() async {
        mockHttpClient.fileName = "card-list"
        mockHttpClient.error = false

        await sut.loadCards()

        XCTAssertFalse(sut.isLoading)
        XCTAssertGreaterThan(sut.items.count, 0, "Should have loaded cards from mock data")
    }

    func testLoadCardsHandlesHttpError() async {
        mockSWDestinyService.retrieveSetCardListError = APIError.invalidData

        await sut.loadCards()

        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showToast)
        XCTAssertEqual(sut.toastType, .error)
    }

    func testAsyncOperationCompletesLoading() async {
        let card = CardDTO.stub(setCode: "AW", code: "01001")

        mockSWDestinyService.retrieveSetCardListResult = [card]

        await sut.loadCards()

        XCTAssertFalse(sut.isLoading)
    }

    func testSearchFilteringByName() async {
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

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        await sut.loadCards()

        sut.performFiltering(searchText: "Phasma")

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].name, "Captain Phasma")
    }

    func testSearchFilteringBySubtitle() async {
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

        mockSWDestinyService.retrieveSetCardListResult = [card1, card2]

        await sut.loadCards()

        sut.performFiltering(searchText: "Vader")

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].name, "Kylo Ren")
    }

    func testColorFiltering() async {
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

        mockSWDestinyService.retrieveSetCardListResult = [redCard, blueCard]

        await sut.loadCards()

        sut.filter.selectedColors.insert("red")
        sut.performFiltering(searchText: "")

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].factionCode, "red")
    }

    func testTypeFiltering() async {
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

        mockSWDestinyService.retrieveSetCardListResult = [character, upgrade]

        await sut.loadCards()

        sut.filter.selectedTypes.insert("character")
        sut.performFiltering(searchText: "")

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].typeCode, "character")
    }

    func testCostFiltering() async {
        let lowCostCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "red",
            code: "01001",
            name: "Card 1",
            cost: 1
        )
        let midCostCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "blue",
            code: "01002",
            name: "Card 2",
            cost: 3
        )
        let highCostCard = CardDTO.stub(
            setCode: "AW",
            factionCode: "red",
            code: "01003",
            name: "Card 3",
            cost: 5
        )

        mockSWDestinyService.retrieveSetCardListResult = [lowCostCard, midCostCard, highCostCard]

        await sut.loadCards()

        sut.filter.selectedColors.insert("blue")
        sut.performFiltering(searchText: "")

        XCTAssertEqual(sut.filteredItems.count, 1)
        XCTAssertEqual(sut.filteredItems[0].cost, 3)
    }

    func testPropertyLoadingAlwaysCompletes() async {
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

            mockSWDestinyService.retrieveSetCardListResult = randomCards

            let testViewModel = CardListViewModel(set: testSet, dependencyContainer: testContainer.container)
            await testViewModel.loadCards()

            XCTAssertFalse(testViewModel.isLoading, "Loading should complete on iteration \(iteration)")
            XCTAssertEqual(testViewModel.items.count, randomCardCount, "Should load correct number of cards on iteration \(iteration)")
        }
    }
}
