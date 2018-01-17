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
        if self.factionCode == "red" {
            return ColorPalette.red
        } else if self.factionCode == "yellow" {
            return  ColorPalette.yellow
        } else if self.factionCode == "blue" {
            return  ColorPalette.blue
        } else if self.factionCode == "gray" {
            return ColorPalette.gray
        }
        return .clear
    }
}
