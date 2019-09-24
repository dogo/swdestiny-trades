//
//  AddCardView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddCardView: UIView, BaseViewConfiguration {

    let searchBar: SearchBar = {
        let view = SearchBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let addCardTableView: AddCardTableView = {
        let view = AddCardTableView(frame: .zero)
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

    // MARK: - <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(addCardTableView)
        addCardTableView.addSubview(activityIndicator)
    }

    internal func setupConstraints() {
        searchBar
            .topAnchor(equalTo: self.safeTopAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)
            .heightAnchor(equalTo: 44)

        addCardTableView
            .topAnchor(equalTo: self.searchBar.bottomAnchor)
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
