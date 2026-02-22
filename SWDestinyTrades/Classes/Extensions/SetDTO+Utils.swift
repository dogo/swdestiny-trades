//
//  SetDTO+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/05/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import SwiftUI

extension SetDTO {

    var icon: SWDIcon {
        let icons: [String: SWDIcon] = [
            "aw": .icAwakenings,
            "sor": .icSpiritOfRebellion,
            "eaw": .icEmpireAtWar,
            "tpg": .icTwoPlayerGame,
            "leg": .icLegacies,
            "riv": .icRivals,
            "wotf": .icWayOfTheForce,
            "atg": .icAcrossTheGalaxy,
            "conv": .icConvergence,
            "aon": .icAlliesOfNecessity,
            "soh": .icSparkOfHope,
            "cm": .icCovertMissions,
            "tr": .icTransformations,
            "fa": .icFalteringAllegiances,
            "ec": .icEternalConflict,
            "rm": .icRedemption,
            "ap": .icAlteredPaths,
            "pw": .icPartingWords
        ]
        return icons[code.lowercased()] ?? SWDIcon.icUnknown
    }
}
