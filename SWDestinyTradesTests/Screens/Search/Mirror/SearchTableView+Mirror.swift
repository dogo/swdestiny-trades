//
//  SearchTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 09/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension SearchTableView {

    var searchDatasource: SearchDatasource? {
        Mirror.extract(variable: "searchDatasource", from: self)
    }
}
