//
//  DeckListTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension DeckListTableView {

    var tableViewDatasource: DeckListDatasource? {
        Mirror.extract(variable: "tableViewDatasource", from: self)
    }
}
