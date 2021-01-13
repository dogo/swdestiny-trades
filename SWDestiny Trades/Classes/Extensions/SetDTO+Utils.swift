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
        if code.lowercased() == "aw" {
            return Asset.Sets.icAwakenings.image
        } else if code.lowercased() == "sor" {
            return Asset.Sets.icSpiritOfRebellion.image
        } else if code.lowercased() == "eaw" {
            return Asset.Sets.icEmpireAtWar.image
        } else if code.lowercased() == "tpg" {
            return Asset.Sets.icTwoPlayerGame.image
        } else if code.lowercased() == "leg" {
            return Asset.Sets.icLegacies.image
        } else if code.lowercased() == "riv" {
            return Asset.Sets.icRivals.image
        } else if code.lowercased() == "wotf" {
            return Asset.Sets.icWayOfTheForce.image
        } else if code.lowercased() == "atg" {
            return Asset.Sets.icAcrossTheGalaxy.image
        } else if code.lowercased() == "conv" {
            return Asset.Sets.icConvergence.image
        } else if code.lowercased() == "aon" {
            return Asset.Sets.icAlliesOfNecessity.image
        } else if code.lowercased() == "soh" {
            return Asset.Sets.icSparkOfHope.image
        } else if code.lowercased() == "cm" {
            return Asset.Sets.icCovertMissions.image
        } else if code.lowercased() == "tr" {
            return Asset.Sets.icTransformations.image
        } else if code.lowercased() == "fa" {
            return Asset.Sets.icFalteringAllegiances.image
        } else if code.lowercased() == "ec" {
            return Asset.Sets.icEternalConflict.image
        } else {
            return Asset.Sets.icNotFound.image
        }
    }
}
