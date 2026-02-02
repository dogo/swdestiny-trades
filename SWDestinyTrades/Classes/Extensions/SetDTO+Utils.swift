//
//  SetDTO+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/05/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import SwiftUI

extension SetDTO {

    var icon: Image {
        let icons: [String: Image] = [
            "aw": Asset.Sets.icAwakenings.swiftUIImage,
            "sor": Asset.Sets.icSpiritOfRebellion.swiftUIImage,
            "eaw": Asset.Sets.icEmpireAtWar.swiftUIImage,
            "tpg": Asset.Sets.icTwoPlayerGame.swiftUIImage,
            "leg": Asset.Sets.icLegacies.swiftUIImage,
            "riv": Asset.Sets.icRivals.swiftUIImage,
            "wotf": Asset.Sets.icWayOfTheForce.swiftUIImage,
            "atg": Asset.Sets.icAcrossTheGalaxy.swiftUIImage,
            "conv": Asset.Sets.icConvergence.swiftUIImage,
            "aon": Asset.Sets.icAlliesOfNecessity.swiftUIImage,
            "soh": Asset.Sets.icSparkOfHope.swiftUIImage,
            "cm": Asset.Sets.icCovertMissions.swiftUIImage,
            "tr": Asset.Sets.icTransformations.swiftUIImage,
            "fa": Asset.Sets.icFalteringAllegiances.swiftUIImage,
            "ec": Asset.Sets.icEternalConflict.swiftUIImage,
            "rm": Asset.Sets.icRedemption.swiftUIImage,
            "hs": Asset.Sets.icHighStakes.swiftUIImage,
            "pw": Asset.Sets.icPartingWords.swiftUIImage
        ]
        return icons[code.lowercased()] ?? Asset.Sets.icNotFound.swiftUIImage
    }
}
