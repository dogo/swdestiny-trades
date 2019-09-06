//
//  SearchView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SearchView: UIView, BaseViewConfiguration {

    let searchBar: SearchBar = {
        let view = SearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let searchTableView: SearchTableView = {
        let view = SearchTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
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
        self.addSubview(searchBar)
        self.addSubview(searchTableView)
        searchTableView.addSubview(activityIndicator)
    }

    internal func setupConstraints() {
        searchBar
            .topAnchor(equalTo: self.safeTopAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)
            .heightAnchor(equalTo: 44)

        searchTableView
            .topAnchor(equalTo: self.searchBar.bottomAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .bottomAnchor(equalTo: self.safeBottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)

        activityIndicator
            .centerXAnchor(equalTo: self.centerXAnchor)
            .centerYAnchor(equalTo: self.centerYAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
