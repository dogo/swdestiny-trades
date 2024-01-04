//
//  AddToDeckCardDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 04/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension AddToDeckCardDatasource {

    var searchIsActive: Bool {
        Mirror.extract(variable: "searchIsActive", from: self)!
    }

    var cardsData: [CardDTO] {
        Mirror.extract(variable: "cardsData", from: self)!
    }

    var filtered: [CardDTO] {
        Mirror.extract(variable: "filtered", from: self)!
    }
}
