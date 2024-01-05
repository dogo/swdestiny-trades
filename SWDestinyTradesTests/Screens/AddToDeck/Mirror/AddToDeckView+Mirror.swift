//
//  AddToDeckView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension AddToDeckView {

    var activityIndicator: UIActivityIndicatorView {
        Mirror.extract(variable: "activityIndicator", from: self)!
    }

    var addToDeckTableView: AddToDeckTableView {
        Mirror.extract(variable: "addToDeckTableView", from: self)!
    }

    var searchBar: SearchBar {
        Mirror.extract(variable: "searchBar", from: self)!
    }
}
