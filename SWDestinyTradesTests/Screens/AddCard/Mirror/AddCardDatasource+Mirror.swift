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
}
