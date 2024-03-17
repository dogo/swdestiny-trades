//
//  SearchView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 17/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension SearchView {

    var activityIndicator: UIActivityIndicatorView {
        Mirror.extract(variable: "activityIndicator", from: self)!
    }

    var searchTableView: SearchTableView {
        Mirror.extract(variable: "searchTableView", from: self)!
    }

    var searchBar: SearchBar {
        Mirror.extract(variable: "searchBar", from: self)!
    }
}
