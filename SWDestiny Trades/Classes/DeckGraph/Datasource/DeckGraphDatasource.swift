//
//  DeckGraphDatasource.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 23/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckGraphDatasource: NSObject, UICollectionViewDataSource {

    fileprivate var cardCosts: [Int] = []
    fileprivate var cardTypes: [Int] = []
    fileprivate var dieFaces: [Int] = []
    fileprivate var collectionView: UICollectionView?

    enum GraphType: Int {
        case
        BarGraph,
        LineGraph,
        RadarGraph

        static func count() -> Int {
            return 3
        }
    }

    required init(collectionView: UICollectionView, delegate: UICollectionViewDelegate) {
        super.init()
        self.collectionView = collectionView
        collectionView.register(cellType: CardTypeBarChartCell.self)
        collectionView.register(cellType: CardCostLineChartCell.self)
        collectionView.register(cellType: DiceRadarChartCell.self)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = delegate
        self.collectionView?.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch GraphType(rawValue: indexPath.row)! {
        case .BarGraph:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardTypeBarChartCell.self)
                cell.configureCell(dataValues: cardTypes)
                return cell
        case .LineGraph:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardCostLineChartCell.self)
                cell.configureCell(dataValues: cardCosts)
                return cell
        case .RadarGraph:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DiceRadarChartCell.self)
                cell.configureCell(dataValues: dieFaces)
                return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GraphType.count()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func updateCollecionViewData(deck: DeckDTO) {
        generateGraphData(deck: deck)
        collectionView?.reloadData()
    }

    func generateGraphData(deck: DeckDTO) {
        // BarChart
        let upgrades = deck.list.filter("typeCode == 'upgrade'").count
        let supports = deck.list.filter("typeCode == 'support'").count
        let events = deck.list.filter("typeCode == 'event'").count
        if !(events == 0 && supports == 0 && upgrades == 0) {
            cardTypes = [upgrades, supports, events]
        }

        // LineChart
        if let id = deck.list.max(ofProperty: "cost") as Int? {
            for i in 0...id {
                cardCosts.append(deck.list.filter("cost == \(i) AND typeCode != 'character' AND typeCode != 'battlefield'").count)
            }
        }

        // RadarChart
        var specialFace = 0, blankFace = 0, meleeFace = 0, rangedFace = 0, focusFace = 0
        var disruptFace = 0, shieldFace = 0, discardFace = 0, resourceFace = 0
        for card in deck.list {
            specialFace += card.dieFaces.filter("value LIKE 'Sp'").count
            blankFace += card.dieFaces.filter("value == '-'").count
            meleeFace += card.dieFaces.filter("value LIKE '*MD*'").count
            rangedFace += card.dieFaces.filter("value LIKE '*RD*'").count
            focusFace += card.dieFaces.filter("value LIKE '*F'").count
            disruptFace += card.dieFaces.filter("value LIKE '*Dr*'").count
            shieldFace += card.dieFaces.filter("value LIKE '*Sh'").count
            discardFace += card.dieFaces.filter("value LIKE '*Dc*'").count
            resourceFace += card.dieFaces.filter("value LIKE '*R'").count
        }
        dieFaces = [specialFace, blankFace, meleeFace, rangedFace, focusFace, disruptFace, shieldFace, discardFace, resourceFace]
    }
}

class DeckGraph: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var delegate: BaseDelegate?

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 16)
        return CGSize(width: width, height: width * CGFloat(1.1))
    }
}
