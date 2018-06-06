//
//  PeopleListView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class PeopleListView: UIView, BaseViewConfiguration {

    let peopleListTableView = PeopleListTableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: <BaseViewConfiguration>

    internal func buildViewHierarchy() {
        self.addSubview(peopleListTableView)
    }

    internal func setupConstraints() {
        peopleListTableView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
        }
    }

    internal func configureViews() {
        self.backgroundColor = .white
    }
}
