//
//  GraphView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class GraphView: UIView {

    let deckGraphCollectionView = DeckGraphCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GraphView: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        self.addSubview(deckGraphCollectionView)
    }

    internal func setupConstraints() {
        deckGraphCollectionView.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
            view.bottomAnchor(equalTo: self.safeBottomAnchor)
        }
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
