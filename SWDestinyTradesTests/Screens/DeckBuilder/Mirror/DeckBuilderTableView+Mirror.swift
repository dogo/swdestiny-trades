//
//  DeckBuilderTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 09/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension DeckBuilderTableView {

    var tableViewDatasource: DeckBuilderDatasource {
        Mirror.extract(variable: "tableViewDatasource", from: self)!
    }
}
