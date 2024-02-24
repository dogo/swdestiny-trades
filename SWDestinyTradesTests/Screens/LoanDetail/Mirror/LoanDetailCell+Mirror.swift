//
//  LoanDetailCell+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension LoanDetailCell {

    var iconImageView: UIImageView {
        Mirror.extract(variable: "iconImageView", from: self)!
    }

    var titleLabel: UILabel {
        Mirror.extract(variable: "titleLabel", from: self)!
    }

    var subtitleLabel: UILabel {
        Mirror.extract(variable: "subtitleLabel", from: self)!
    }

    var quantityLabel: UILabel {
        Mirror.extract(variable: "quantityLabel", from: self)!
    }

    var quantityStepper: UIStepper {
        Mirror.extract(variable: "quantityStepper", from: self)!
    }
}
