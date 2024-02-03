//
//  CardListView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension CardListView {

    var activityIndicator: UIActivityIndicatorView {
        Mirror.extract(variable: "activityIndicator", from: self)!
    }

    var cardListTableView: CardListTableView {
        Mirror.extract(variable: "cardListTableView", from: self)!
    }
}
