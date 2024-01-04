//
//  AddToDeckView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

protocol AddToDeckViewProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func updateSearchList(_ cards: [CardDTO])
    func doingSearch(_ query: String)
    func showSuccessMessage(card: CardDTO)
}

final class AddToDeckView: UIView, AddToDeckViewType {

    var didSelectCard: ((CardDTO) -> Void)? {
        didSet {
            addToDeckTableView.didSelectCard = didSelectCard
        }
    }

    var didSelectAccessory: ((CardDTO) -> Void)? {
        didSet {
            addToDeckTableView.didSelectAccessory = didSelectAccessory
        }
    }

    var doingSearch: ((String) -> Void)? {
        didSet {
            searchBar.doingSearch = doingSearch
        }
    }

    var didSelectRemote: (() -> Void)? {
        didSet {
            addToDeckTableView.didSelectRemote = didSelectRemote
        }
    }

    var didSelectLocal: (() -> Void)? {
        didSet {
            addToDeckTableView.didSelectLocal = didSelectLocal
        }
    }

    private let searchBar = SearchBar(frame: .zero)

    private let addToDeckTableView = AddToDeckTableView(frame: .zero)

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

    func updateSearchList(_ cards: [CardDTO]) {
        addToDeckTableView.updateSearchList(cards)
    }

    func doingSearch(_ query: String) {
        addToDeckTableView.doingSearch(query)
    }
}

extension AddToDeckView: BaseViewConfiguration {
    func buildViewHierarchy() {
        addSubview(searchBar)
        addSubview(addToDeckTableView)
        addToDeckTableView.addSubview(activityIndicator)
    }

    func setupConstraints() {
        searchBar.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
            view.heightAnchor(equalToConstant: 44)
        }

        addToDeckTableView.layout.applyConstraint { view in
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
