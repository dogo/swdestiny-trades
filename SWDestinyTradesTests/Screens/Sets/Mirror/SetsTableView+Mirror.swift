//
//  SetsTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension SetsTableView {

    var tableViewDatasource: SetsListDatasource? {
        Mirror.extract(variable: "tableViewDatasource", from: self)
    }
}
