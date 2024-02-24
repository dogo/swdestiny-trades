//
//  LoanDetailTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension LoanDetailTableView {

    var tableViewDatasource: LoansDetailDatasource {
        Mirror.extract(variable: "tableViewDatasource", from: self)!
    }
}
