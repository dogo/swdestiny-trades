//
//  SetDTO+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/05/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

extension SetDTO {
    // swiftlint:disable:next cyclomatic_complexity
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
        } else if self.code.lowercased() == "wotf" {
            return Asset.Sets.icWayOfTheForce.image
        } else if self.code.lowercased() == "atg" {
            return Asset.Sets.icAcrossTheGalaxy.image
        } else if self.code.lowercased() == "conv" {
            return Asset.Sets.icConvergence.image
        } else if self.code.lowercased() == "aon" {
            return Asset.Sets.icAlliesOfNecessity.image
        } else if self.code.lowercased() == "soh" {
            return Asset.Sets.icSparkOfHope.image
        } else if self.code.lowercased() == "cm" {
            return Asset.Sets.icCovertMissions.image
        } else if self.code.lowercased() == "tr" {
            return Asset.Sets.icTransformations.image
        } else if self.code.lowercased() == "fa" {
            return Asset.Sets.icFalteringAllegiances.image
        } else {
            return Asset.Sets.icNotFound.image
        }
    }
}
