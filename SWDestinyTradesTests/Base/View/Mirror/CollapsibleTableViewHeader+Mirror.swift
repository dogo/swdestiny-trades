//
//  CollapsibleTableViewHeader+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit

@testable import SWDestinyTrades

extension CollapsibleTableViewHeader {

    var arrowLabel: UILabel {
        Mirror.extract(variable: "arrowLabel", from: self)!
    }
}
