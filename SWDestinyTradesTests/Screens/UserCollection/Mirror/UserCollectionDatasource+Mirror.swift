//
//  UserCollectionDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension UserCollectionDatasource {

    var collectionList: [CardDTO]? {
        Mirror.extract(variable: "collectionList", from: self)
    }
}
