//
//  CardView+Mirror.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import ImageSlideshow
import UIKit

@testable import SWDestinyTrades

extension CardView {

    var slideshow: ImageSlideshow {
        Mirror.extract(variable: "slideshow", from: self)!
    }
}
