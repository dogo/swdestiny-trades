//
//  AddCardDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 30/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension AddCardDatasource {

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
