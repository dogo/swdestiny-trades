//
//  SetsListDatasource+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension SetsListDatasource {

    var swdSets: [String: [SetDTO]] {
        Mirror.extract(variable: "swdSets", from: self)!
    }

    var sections: [String] {
        Mirror.extract(variable: "sections", from: self)!
    }
}
