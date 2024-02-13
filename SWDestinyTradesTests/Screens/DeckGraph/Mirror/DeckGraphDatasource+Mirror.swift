//
//  DeckGraphDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 13/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension DeckGraphDatasource {

    var cardCosts: [Int] {
        Mirror.extract(variable: "cardCosts", from: self)!
    }

    var cardTypes: [Int] {
        Mirror.extract(variable: "cardTypes", from: self)!
    }

    var dieFaces: [Int] {
        Mirror.extract(variable: "dieFaces", from: self)!
    }
}
