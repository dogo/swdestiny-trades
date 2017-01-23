//
//  GraphView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class GraphView: UIView, BaseViewConfiguration {

    let deckGraphCollectionView = DeckGraphCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(deckGraphCollectionView)
    }

    internal func setupConstraints() {
        deckGraphCollectionView.snp.makeConstraints { make in
            make.top.equalTo(64)
            make.left.equalTo(self)
            make.bottom.equalTo(self).offset(-49)
            make.right.equalTo(self)
        }
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
