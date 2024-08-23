//
//  ColorListDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension ColorListDatasource {

    var colorCards: [String: [CardDTO]] {
        Mirror.extract(variable: "colorCards", from: self)!
    }

    var sections: [String] {
        Mirror.extract(variable: "sections", from: self)!
    }
}
