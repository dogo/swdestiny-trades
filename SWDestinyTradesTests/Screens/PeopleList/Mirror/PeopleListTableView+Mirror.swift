//
//  PeopleListTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension PeopleListTableView {

    var tableViewDatasource: PeopleListDatasource {
        Mirror.extract(variable: "tableViewDatasource", from: self)!
    }
}
