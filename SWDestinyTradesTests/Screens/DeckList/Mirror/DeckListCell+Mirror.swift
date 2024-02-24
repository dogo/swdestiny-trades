//
//  DeckListCell+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension DeckListCell {

    var titleEditText: UITextField {
        Mirror.extract(variable: "titleEditText", from: self)!
    }

    var subTitle: UILabel {
        Mirror.extract(variable: "subTitle", from: self)!
    }

    var accessoryButton: UIButton {
        Mirror.extract(variable: "accessoryButton", from: self)!
    }
}
