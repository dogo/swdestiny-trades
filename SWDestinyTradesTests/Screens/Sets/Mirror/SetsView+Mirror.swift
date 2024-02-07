//
//  SetsView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension SetsView {

    var setsTableView: SetsTableView? {
        Mirror.extract(variable: "setsTableView", from: self)
    }

    var pullToRefresh: UIRefreshControl {
        Mirror.extract(variable: "pullToRefresh", from: self)!
    }

    var activityIndicator: UIActivityIndicatorView {
        Mirror.extract(variable: "activityIndicator", from: self)!
    }
}
