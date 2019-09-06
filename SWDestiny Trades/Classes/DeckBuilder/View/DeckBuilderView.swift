//
//  DeckBuilderView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderView: UIView, BaseViewConfiguration {

    let deckBuilderTableView: DeckBuilderTableView = {
       let view = DeckBuilderTableView(frame: .zero)
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
        self.addSubview(deckBuilderTableView)
    }

    internal func setupConstraints() {
        deckBuilderTableView
            .topAnchor(equalTo: self.topAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .bottomAnchor(equalTo: self.bottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
