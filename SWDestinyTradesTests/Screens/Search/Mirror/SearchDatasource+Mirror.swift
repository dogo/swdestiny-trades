//
//  SearchDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension SearchDatasource {

    var cardsData: [CardDTO] {
        Mirror.extract(variable: "cardsData", from: self)!
    }
}
