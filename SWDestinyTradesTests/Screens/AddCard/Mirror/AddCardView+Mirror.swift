//
//  AddCardView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 30/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension AddCardView {

    var activityIndicator: UIActivityIndicatorView {
        Mirror.extract(variable: "activityIndicator", from: self)!
    }

    var addCardTableView: AddCardTableView {
        Mirror.extract(variable: "addCardTableView", from: self)!
    }

    var searchBar: SearchBar {
        Mirror.extract(variable: "searchBar", from: self)!
    }
}
