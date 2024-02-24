//
//  LoansDetailDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension LoansDetailDatasource {

    var lentMe: [CardDTO] {
        Mirror.extract(variable: "lentMe", from: self)!
    }

    var borrowed: [CardDTO] {
        Mirror.extract(variable: "borrowed", from: self)!
    }
}
