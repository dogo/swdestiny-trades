//
//  UserCollectionView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 15/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class UserCollectionView: UIView, BaseViewConfiguration {

    let userCollectionTableView: UserCollectionTableView = {
        let view = UserCollectionTableView()
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
        self.addSubview(userCollectionTableView)
    }

    internal func setupConstraints() {
        userCollectionTableView
            .topAnchor(equalTo: self.topAnchor)
            .leadingAnchor(equalTo: self.leadingAnchor)
            .bottomAnchor(equalTo: self.bottomAnchor)
            .trailingAnchor(equalTo: self.trailingAnchor)
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
