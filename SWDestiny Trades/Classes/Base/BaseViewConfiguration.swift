//
//  BaseViewConfiguration.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import SnapKit

protocol BaseViewConfiguration {
    func setupConstraints()
    func buildViewHierarchy()
    func configureViews()
}
