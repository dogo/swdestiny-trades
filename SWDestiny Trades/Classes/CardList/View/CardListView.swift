//
//  CardListView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListView: UIView, BaseViewConfiguration {

    let cardListTableView: CardListTableView = {
        let view = CardListTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.color = .whiteBlack
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
        self.addSubview(cardListTableView)
        cardListTableView.addSubview(activityIndicator)
    }

    internal func setupConstraints() {
        cardListTableView
            .topAnchor(equalTo: self.safeTopAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .bottomAnchor(equalTo: self.safeBottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)

        activityIndicator
            .centerXAnchor(equalTo: self.centerXAnchor)
            .centerYAnchor(equalTo: self.centerYAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .blackWhite
    }
}
