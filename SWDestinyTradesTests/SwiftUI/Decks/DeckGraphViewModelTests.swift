//
//  DeckGraphViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

@MainActor
final class DeckGraphViewModelTests: BaseTestCase {

    private func card(type: String, cost: Int, quantity: Int, dieFaces: [String] = []) -> CardDTO {
        let card = CardDTO.stub(typeCode: type, cost: cost, quantity: quantity)
        card.dieFaces = dieFaces
        return card
    }

    private func makeSUT(cards: [CardDTO]) async -> DeckGraphViewModel {
        let deck = DeckDTO()
        deck.list = cards
        let sut = DeckGraphViewModel(deck: deck, dependencyContainer: testContainer.container)
        await waitUntil { !sut.isLoading }
        return sut
    }

    // MARK: - Bar chart (card types)

    func test_generateGraphData_buildsCardTypeCountsByQuantity() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 2),
            card(type: "support", cost: 3, quantity: 1),
            card(type: "event", cost: 2, quantity: 1)
        ])

        // [upgrades, supports, events, plots, downgrades]
        XCTAssertEqual(sut.cardTypeData, [2, 1, 1, 0, 0])
        XCTAssertTrue(sut.hasData)
    }

    func test_generateGraphData_emptyDeck_hasNoData() async {
        let sut = await makeSUT(cards: [])

        XCTAssertFalse(sut.hasData)
        XCTAssertTrue(sut.cardTypeData.isEmpty)
    }

    func test_generateGraphData_noChartableTypes_returnsEmptyBarData() async {
        let sut = await makeSUT(cards: [
            card(type: "character", cost: 2, quantity: 1)
        ])

        XCTAssertTrue(sut.cardTypeData.isEmpty)
        XCTAssertTrue(sut.hasData) // deck is not empty, even if no bar-chartable types
    }

    // MARK: - Line chart (card costs)

    func test_generateGraphData_buildsCostHistogramExcludingCharacters() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 2),
            card(type: "event", cost: 2, quantity: 1),
            card(type: "support", cost: 3, quantity: 1),
            card(type: "character", cost: 3, quantity: 1) // excluded from cost histogram
        ])

        // Index = cost (0...maxCost=3); character at cost 3 is excluded.
        XCTAssertEqual(sut.cardCostData, [0, 2, 1, 1])
    }

    // MARK: - Radar chart (dice faces)

    func test_generateGraphData_countsDiceFaces() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 2, dieFaces: ["2MD"])
        ])

        // diceFaceLabels index 2 == Melee, matched by the "*MD*" filter; quantity 2.
        XCTAssertEqual(sut.diceFaceData.count, 10)
        XCTAssertEqual(sut.diceFaceData[2], 2)
    }

    // MARK: - Chart helpers

    func test_getChartTitle_returnsLocalizedTitles() async {
        let sut = await makeSUT(cards: [])

        XCTAssertEqual(sut.getChartTitle(for: .cardTypes), L10n.cardTypes)
        XCTAssertEqual(sut.getChartTitle(for: .cardCosts), L10n.cardCost)
        XCTAssertEqual(sut.getChartTitle(for: .diceSymbols), L10n.diceSymbols)
    }

    func test_hasChartData_reflectsComputedData() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 1)
        ])

        XCTAssertTrue(sut.hasChartData(for: .cardTypes))
        XCTAssertTrue(sut.hasChartData(for: .cardCosts))
    }

    func test_refresh_recomputesData() async {
        let sut = await makeSUT(cards: [card(type: "upgrade", cost: 1, quantity: 1)])

        sut.deck.list = []
        sut.refresh()
        await waitUntil { !sut.isLoading && !sut.hasData }

        XCTAssertFalse(sut.hasData)
    }
}
