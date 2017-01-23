//
//  SearchView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class SearchView: UIView, BaseViewConfiguration {

    let searchBar = SearchBar()
    let searchTableView = SearchTableView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

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
        self.addSubview(searchBar)
        self.addSubview(searchTableView)
        searchTableView.addSubview(activityIndicator)
    }

    internal func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self).offset(44+20)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(44)
        }

        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
