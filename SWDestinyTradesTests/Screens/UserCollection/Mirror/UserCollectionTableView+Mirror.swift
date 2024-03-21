//
//  UserCollectionTableView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 21/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension UserCollectionTableView {

    var tableViewDatasource: UserCollectionDatasource? {
        Mirror.extract(variable: "tableViewDatasource", from: self)
    }
}
