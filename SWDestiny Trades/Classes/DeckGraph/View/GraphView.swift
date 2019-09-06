//
//  GraphView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class GraphView: UIView, BaseViewConfiguration {

    let deckGraphCollectionView: DeckGraphCollectionView = {
        let view = DeckGraphCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(deckGraphCollectionView)
    }

    internal func setupConstraints() {
        deckGraphCollectionView
            .topAnchor(equalTo: self.safeTopAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)
            .bottomAnchor(equalTo: self.safeBottomAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
