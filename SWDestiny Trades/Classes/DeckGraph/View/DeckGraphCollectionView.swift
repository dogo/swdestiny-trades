//
//  DeckGraphCollectionView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 23/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckGraphCollectionView: UICollectionView, BaseDelegate {

    fileprivate var collectionViewDatasource: DeckGraphDatasource?
    fileprivate let deckGraph = DeckGraph()

    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        deckGraph.delegate = self
        collectionViewDatasource = DeckGraphDatasource(collectionView: self, delegate: deckGraph)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCollecionViewData(deck: DeckDTO) {
        collectionViewDatasource?.updateCollecionViewData(deck: deck)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRow(at index: IndexPath) {
    }
}
