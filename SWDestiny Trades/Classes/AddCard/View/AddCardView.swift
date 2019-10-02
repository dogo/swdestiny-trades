//
//  AddCardView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class AddCardView: UIView {

    let searchBar = SearchBar(frame: .zero)
    let addCardTableView = AddCardTableView(frame: .zero)

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
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

extension AddCardView: BaseViewConfiguration {

    internal func buildViewHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(addCardTableView)
        addCardTableView.addSubview(activityIndicator)
    }

    internal func setupConstraints() {
        searchBar.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
            view.heightAnchor(equalTo: 44)
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

    internal func configureViews() {
        self.backgroundColor = .blackWhite
    }
}
