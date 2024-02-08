//
//  SetsTableCell+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension SetsTableCell {

    var titleLabel: UILabel? {
        Mirror.extract(variable: "titleLabel", from: self)
    }

    var expansionImageView: UIImageView? {
        Mirror.extract(variable: "expansionImageView", from: self)
    }
}
