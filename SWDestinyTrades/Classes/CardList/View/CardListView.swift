//
//  CardListView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 09/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class CardListView: UIView, CardListViewType {

    var didSelectCard: (([CardDTO], CardDTO) -> Void)? {
        didSet {
            cardListTableView.didSelectCard = didSelectCard
        }
    }

    private let cardListTableView = CardListTableView()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .whiteBlack
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

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }

    func updateCardList(_ cards: [CardDTO]) {
        cardListTableView.updateCardList(cards)
    }
}

extension CardListView: BaseViewConfiguration {

    func buildViewHierarchy() {
        addSubview(cardListTableView)
        cardListTableView.addSubview(activityIndicator)
    }

    func setupConstraints() {
        cardListTableView.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.bottomAnchor(equalTo: self.safeBottomAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
        }

        activityIndicator.layout.applyConstraint { view in
            view.centerXAnchor(equalTo: self.centerXAnchor)
            view.centerYAnchor(equalTo: self.centerYAnchor)
        }
    }

    func configureViews() {
        backgroundColor = .blackWhite
    }
}
