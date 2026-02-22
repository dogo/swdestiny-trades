//
//  SWDIconView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 21/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

extension Text {
    static func swdIcon(_ icon: SWDIcon, size: CGFloat) -> Text {
        Text(icon.unicode)
            .font(.custom("swdestiny", size: size))
    }
}
