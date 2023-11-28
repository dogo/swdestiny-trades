//
//  AddToDeckView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddToDeckView: UIView {
    let searchBar = SearchBar(frame: .zero)

    let addToDeckTableView = AddToDeckTableView(frame: .zero)

    let activityIndicator: UIActivityIndicatorView = {
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
