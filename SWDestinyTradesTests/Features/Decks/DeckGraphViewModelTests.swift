//
//  DeckGraphViewModelTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Testing

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

    @Test
    func generateGraphData_buildsCardTypeCountsByQuantity() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 2),
            card(type: "support", cost: 3, quantity: 1),
            card(type: "event", cost: 2, quantity: 1)
        ])

        // [upgrades, supports, events, plots, downgrades]
        #expect(sut.cardTypeData == [2, 1, 1, 0, 0])
        #expect(sut.hasData)
    }

    @Test
    func generateGraphData_emptyDeck_hasNoData() async {
        let sut = await makeSUT(cards: [])

        #expect(sut.hasData == false)
        #expect(sut.cardTypeData.isEmpty)
    }

    @Test
    func generateGraphData_noChartableTypes_returnsEmptyBarData() async {
        let sut = await makeSUT(cards: [
            card(type: "character", cost: 2, quantity: 1)
        ])

        #expect(sut.cardTypeData.isEmpty)
        #expect(sut.hasData) // deck is not empty, even if no bar-chartable types
    }

    // MARK: - Line chart (card costs)

    @Test
    func generateGraphData_buildsCostHistogramExcludingCharacters() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 2),
            card(type: "event", cost: 2, quantity: 1),
            card(type: "support", cost: 3, quantity: 1),
            card(type: "character", cost: 3, quantity: 1) // excluded from cost histogram
        ])

        // Index = cost (0...maxCost=3); character at cost 3 is excluded.
        #expect(sut.cardCostData == [0, 2, 1, 1])
    }

    // MARK: - Radar chart (dice faces)

    @Test
    func generateGraphData_countsDiceFaces() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 2, dieFaces: ["2MD"])
        ])

        // diceFaceLabels index 2 == Melee, matched by the "*MD*" filter; quantity 2.
        #expect(sut.diceFaceData.count == 10)
        #expect(sut.diceFaceData[2] == 2)
    }

    // MARK: - Chart helpers

    @Test
    func getChartTitle_returnsLocalizedTitles() async {
        let sut = await makeSUT(cards: [])

        #expect(sut.getChartTitle(for: .cardTypes) == L10n.cardTypes)
        #expect(sut.getChartTitle(for: .cardCosts) == L10n.cardCost)
        #expect(sut.getChartTitle(for: .diceSymbols) == L10n.diceSymbols)
    }

    @Test
    func hasChartData_reflectsComputedData() async {
        let sut = await makeSUT(cards: [
            card(type: "upgrade", cost: 1, quantity: 1)
        ])

        #expect(sut.hasChartData(for: .cardTypes))
        #expect(sut.hasChartData(for: .cardCosts))
    }

    @Test
    func refresh_recomputesData() async {
        let sut = await makeSUT(cards: [card(type: "upgrade", cost: 1, quantity: 1)])

        sut.deck.list = []
        sut.refresh()
        await waitUntil { !sut.isLoading && !sut.hasData }

        #expect(sut.hasData == false)
    }
}
