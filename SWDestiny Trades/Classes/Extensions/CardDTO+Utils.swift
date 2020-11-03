//
//  CardDTO+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 17/01/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

extension CardDTO {
    func factionColor() -> UIColor {
        if factionCode == "red" {
            return ColorPalette.red
        } else if factionCode == "yellow" {
            return ColorPalette.yellow
        } else if factionCode == "blue" {
            return ColorPalette.blue
        } else if factionCode == "gray" {
            return ColorPalette.gray
        }
        return .clear
    }
}
