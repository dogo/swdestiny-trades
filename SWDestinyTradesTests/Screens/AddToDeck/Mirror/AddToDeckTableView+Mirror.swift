//
//  AddToDeckTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension AddToDeckTableView {

    var tableDatasource: AddToDeckCardDatasource {
        Mirror.extract(variable: "tableDatasource", from: self)!
    }
}
