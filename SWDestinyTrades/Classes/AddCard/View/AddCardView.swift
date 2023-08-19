//
//  AddCardView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddCardView: UIView, AddCardViewType {

    private let searchBar = SearchBar(frame: .zero)
    private let addCardTableView = AddCardTableView(frame: .zero)

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.color = .whiteBlack
        return view
    }()

    var didSelectCard: ((CardDTO) -> Void)? {
        didSet {
            addCardTableView.didSelectCard = didSelectCard
        }
    }

    var didSelectAccessory: ((CardDTO) -> Void)? {
        didSet {
            addCardTableView.didSelectAccessory = didSelectAccessory
        }
    }

    var doingSearch: ((String) -> Void)? {
        didSet {
            searchBar.doingSearch = doingSearch
        }
    }

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

    func updateSearchList(_ cards: [CardDTO]) {
        addCardTableView.updateSearchList(cards)
    }

    func doingSearch(_ query: String) {
        addCardTableView.doingSearch(query)
    }
}

extension AddCardView: BaseViewConfiguration {

    func buildViewHierarchy() {
        addSubview(searchBar)
        addSubview(addCardTableView)
        addCardTableView.addSubview(activityIndicator)
    }

    func setupConstraints() {
        searchBar.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
            view.heightAnchor(equalToConstant: 44)
        }

        addCardTableView.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.searchBar.bottomAnchor)
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
