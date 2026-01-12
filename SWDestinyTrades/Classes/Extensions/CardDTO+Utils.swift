//
//  CardDTO+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 17/01/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import SwiftUI

extension CardDTO {
    func factionColor() -> Color {
        let colorMapping: [String: Color] = [
            "red": ColorPalette.red,
            "yellow": ColorPalette.yellow,
            "blue": ColorPalette.blue,
            "gray": ColorPalette.gray
        ]
        return colorMapping[factionCode] ?? .clear
    }
}
