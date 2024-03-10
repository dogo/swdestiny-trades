//
//  CardSearchCell+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 10/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension CardSearchCell {

    var baseViewCell: BaseViewCell {
        Mirror.extract(variable: "baseViewCell", from: self)!
    }
}
