//
//  DeckGraphDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 23/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckGraphDatasource: NSObject, UICollectionViewDataSource {

    private var cardCosts: [Int] = []
    private var cardTypes: [Int] = []
    private var dieFaces: [Int] = []
    private var collectionView: UICollectionView?

    enum GraphType: Int, CaseIterable {
        case
            barGraph,
            lineGraph,
            radarGraph
    }

    required init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        collectionView.register(cellType: CardTypeBarChartCell.self)
        collectionView.register(cellType: CardCostLineChartCell.self)
        collectionView.register(cellType: DiceRadarChartCell.self)
        self.collectionView?.dataSource = self
        self.collectionView?.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let graphType = GraphType(rawValue: indexPath.row) {
            switch graphType {
            case .barGraph:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardTypeBarChartCell.self)
                cell.configureCell(dataValues: cardTypes)
                return cell
            case .lineGraph:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardCostLineChartCell.self)
                cell.configureCell(dataValues: cardCosts)
                return cell
            case .radarGraph:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DiceRadarChartCell.self)
                cell.configureCell(dataValues: dieFaces)
                return cell
            }
        }
        // return the default cell if none of above succeed
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GraphType.allCases.count
    }

    func updateCollecionViewData(deck: DeckDTO) {
        generateGraphData(deck: deck)
        collectionView?.reloadData()
    }

    private func generateGraphData(deck: DeckDTO) {
        // BarChart
        buildBarChart(deck: deck)

        // LineChart
        buildLineChart(deck: deck)

        // RadarChart
        buildRadarChart(deck: deck)
    }

    private func buildBarChart(deck: DeckDTO) {
        var upgrades = 0
        var supports = 0
        var events = 0
        var plots = 0
        var downgrades = 0

        for card in deck.list {
            switch card.typeCode {
            case "upgrade":
                upgrades += card.quantity
            case "support":
                supports += card.quantity
            case "event":
                events += card.quantity
            case "plot":
                plots += card.quantity
            case "downgrade":
                downgrades += card.quantity
            default:
                break
            }
        }

        if !(events == 0 && supports == 0 && upgrades == 0 && plots == 0 && downgrades == 0) {
            cardTypes = [upgrades, supports, events, plots, downgrades]
        }
    }

    private func buildLineChart(deck: DeckDTO) {
        if let maxCost = deck.list.max(ofProperty: "cost") as Int? {
            for cost in 0 ... maxCost {
                let cardCost = deck.list
                    .filter { $0.cost == cost && !["character", "battlefield", "plot"].contains($0.typeCode) }
                    .map(\.quantity)
                    .reduce(0, +)

                cardCosts.append(cardCost)
            }
        }
    }

    private func buildRadarChart(deck: DeckDTO) {
        let filters = ["Sp", "-", "*MD*", "*RD*", "*F", "*Dr*", "*Sh", "*Dc*", "*R", "*ID*"]
        dieFaces = filters.compactMap { countFaces(deck: deck, filter: "value LIKE '\($0)'") }
    }

    private func countFaces(deck: DeckDTO, filter: String) -> Int {
        return deck.list.reduce(0) { $0 + $1.dieFaces.filter(filter).count * $1.quantity }
    }
}
