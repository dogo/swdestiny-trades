//
//  DeckGraphCollectionView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 23/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckGraphCollectionView: UICollectionView {

    fileprivate var collectionViewDatasource: DeckGraphDatasource?

    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        collectionViewDatasource = DeckGraphDatasource(collectionView: self)
        self.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCollecionViewData(deck: DeckDTO) {
        collectionViewDatasource?.updateCollecionViewData(deck: deck)
    }

    // MARK: <BaseDelegate>

    internal func didSelectRowAt(index: IndexPath) {
    }
}

extension DeckGraphCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 16)
        return CGSize(width: width, height: width * CGFloat(1.1))
    }
}
