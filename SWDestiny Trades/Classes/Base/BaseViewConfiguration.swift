//
//  BaseViewConfiguration.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

protocol BaseViewConfiguration {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
}

extension BaseViewConfiguration {

    func setupBaseView() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    func configureViews() {
    }
}
