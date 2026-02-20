//
//  DeckGraphViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class DeckGraphViewModel: BaseViewModel {

    var deck: DeckDTO
    var cardTypeData: [Int] = []
    var cardCostData: [Int] = []
    var diceFaceData: [Int] = []
    var hasData = false

    let cardTypeLabels = [L10n.upgrade, L10n.support, L10n.event, L10n.plot, L10n.downgrade]
    let diceFaceLabels = ["Special", "Blank", "Melee", "Ranged", "Focus",
                          "Disrupt", "Shield", "Discard", "Resource", "Indirect"]

    init(deck: DeckDTO, dependencyContainer: DependencyContainer = .shared) {
        self.deck = deck
        super.init(dependencyContainer: dependencyContainer)
        generateGraphData()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        deck = DeckDTO()
        super.init(dependencyContainer: dependencyContainer)
    }

    func generateGraphData() {
        setLoading(true)

        let deckListData = Array(deck.list).threadSafeMap { card in
            DeckCardData(
                typeCode: card.typeCode,
                cost: card.cost,
                quantity: card.quantity,
                dieFaces: Array(card.dieFaces)
            )
        }

        Task {
            await self.computeGraphData(deckListData: deckListData)
        }
    }

    private nonisolated func computeGraphData(deckListData: [DeckCardData]) async {
        let cardTypeResult = buildBarChartData(deckListData: deckListData)
        let cardCostResult = buildLineChartData(deckListData: deckListData)
        let diceFaceResult = buildRadarChartData(deckListData: deckListData)

        await updateUI(
            cardTypeData: cardTypeResult,
            cardCostData: cardCostResult,
            diceFaceData: diceFaceResult,
            hasData: !deckListData.isEmpty
        )
    }

    @MainActor
    private func updateUI(cardTypeData: [Int], cardCostData: [Int], diceFaceData: [Int], hasData: Bool) {
        self.cardTypeData = cardTypeData
        self.cardCostData = cardCostData
        self.diceFaceData = diceFaceData
        self.hasData = hasData
        setLoading(false)
    }

    private nonisolated func buildBarChartData(deckListData: [DeckCardData]) -> [Int] {
        var upgrades = 0
        var supports = 0
        var events = 0
        var plots = 0
        var downgrades = 0

        for cardData in deckListData {
            switch cardData.typeCode {
            case "upgrade":
                upgrades += cardData.quantity
            case "support":
                supports += cardData.quantity
            case "event":
                events += cardData.quantity
            case "plot":
                plots += cardData.quantity
            case "downgrade":
                downgrades += cardData.quantity
            default:
                break
            }
        }

        if !(events == 0 && supports == 0 && upgrades == 0 && plots == 0 && downgrades == 0) {
            return [upgrades, supports, events, plots, downgrades]
        } else {
            return []
        }
    }

    private nonisolated func buildLineChartData(deckListData: [DeckCardData]) -> [Int] {
        var costs: [Int] = []

        if let maxCost = deckListData.map(\.cost).max() {
            for cost in 0 ... maxCost {
                let cardCost = deckListData
                    .filter { $0.cost == cost && !["character", "battlefield", "plot"].contains($0.typeCode) }
                    .map(\.quantity)
                    .reduce(0, +)

                costs.append(cardCost)
            }
        }

        return costs
    }

    private nonisolated func buildRadarChartData(deckListData: [DeckCardData]) -> [Int] {
        let filters = ["Sp", "-", "*MD*", "*RD*", "*F", "*Dr*", "*Sh", "*Dc*", "*R", "*ID*"]

        let faces = filters.map { filter in
            countFaces(filter: "value LIKE '\(filter)'", deckListData: deckListData)
        }

        return faces
    }

    private nonisolated func countFaces(filter: String, deckListData: [DeckCardData]) -> Int {
        return deckListData.reduce(0) { total, cardData in
            let matchingFaces = cardData.dieFaces.filter { face in
                evaluateFilter(filter, on: face)
            }.count
            return total + (matchingFaces * cardData.quantity)
        }
    }

    private nonisolated func evaluateFilter(_ filter: String, on value: String) -> Bool {
        let pattern = filter
            .replacingOccurrences(of: "value LIKE '", with: "")
            .replacingOccurrences(of: "'", with: "")

        if pattern.hasPrefix("*"), pattern.hasSuffix("*") {
            let substring = String(pattern.dropFirst().dropLast())
            return value.contains(substring)
        } else if pattern.hasPrefix("*") {
            let substring = String(pattern.dropFirst())
            return value.hasSuffix(substring)
        } else if pattern.hasSuffix("*") {
            let substring = String(pattern.dropLast())
            return value.hasPrefix(substring)
        } else {
            return value == pattern
        }
    }

    func refresh() {
        generateGraphData()
    }

    func getChartTitle(for chartType: ChartType) -> String {
        switch chartType {
        case .cardTypes:
            return L10n.cardTypes
        case .cardCosts:
            return L10n.cardCost
        case .diceSymbols:
            return L10n.diceSymbols
        }
    }

    func hasChartData(for chartType: ChartType) -> Bool {
        switch chartType {
        case .cardTypes:
            return !cardTypeData.isEmpty
        case .cardCosts:
            return !cardCostData.isEmpty
        case .diceSymbols:
            return !diceFaceData.isEmpty
        }
    }
}

enum ChartType: CaseIterable {
    case cardTypes
    case cardCosts
    case diceSymbols

    var title: String {
        switch self {
        case .cardTypes:
            return L10n.cardTypes
        case .cardCosts:
            return L10n.cardCost
        case .diceSymbols:
            return L10n.diceSymbols
        }
    }
}

struct DeckCardData: Sendable {
    let typeCode: String
    let cost: Int
    let quantity: Int
    let dieFaces: [String]
}
