//
//  AddCardCell+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 02/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension AddCardCell {

    var baseViewCell: BaseViewCell {
        Mirror.extract(variable: "baseViewCell", from: self)!
    }
}
