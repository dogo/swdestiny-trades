//
//  SetsView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension SetsView {

    var setsTableView: SetsTableView? {
        Mirror.extract(variable: "setsTableView", from: self)
    }
}
