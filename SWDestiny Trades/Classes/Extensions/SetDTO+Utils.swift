//
//  SetDTO+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/05/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

extension SetDTO {

    func setIcon() -> UIImage {
        if self.code.lowercased() == "aw" {
            return Asset.Sets.icAwakenings.image
        } else if self.code.lowercased() == "sor" {
            return Asset.Sets.icSpiritOfRebellion.image
        } else if self.code.lowercased() == "eaw" {
            return Asset.Sets.icEmpireAtWar.image
        } else if self.code.lowercased() == "tpg" {
            return Asset.Sets.icTwoPlayerGame.image
        } else if self.code.lowercased() == "leg" {
            return Asset.Sets.icLegacies.image
        } else if self.code.lowercased() == "riv" {
            return Asset.Sets.icRivals.image
        } else {
            return Asset.Sets.icNotFound.image
        }
    }
}
