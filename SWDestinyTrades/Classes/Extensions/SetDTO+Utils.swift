//
//  SetDTO+Utils.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 28/05/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit

extension SetDTO {

    var icon: UIImage {
        let icons: [String: UIImage] = [
            "aw": Asset.Sets.icAwakenings.image,
            "sor": Asset.Sets.icSpiritOfRebellion.image,
            "eaw": Asset.Sets.icEmpireAtWar.image,
            "tpg": Asset.Sets.icTwoPlayerGame.image,
            "leg": Asset.Sets.icLegacies.image,
            "riv": Asset.Sets.icRivals.image,
            "wotf": Asset.Sets.icWayOfTheForce.image,
            "atg": Asset.Sets.icAcrossTheGalaxy.image,
            "conv": Asset.Sets.icConvergence.image,
            "aon": Asset.Sets.icAlliesOfNecessity.image,
            "soh": Asset.Sets.icSparkOfHope.image,
            "cm": Asset.Sets.icCovertMissions.image,
            "tr": Asset.Sets.icTransformations.image,
            "fa": Asset.Sets.icFalteringAllegiances.image,
            "ec": Asset.Sets.icEternalConflict.image,
            "rm": Asset.Sets.icRedemption.image,
            "hs": Asset.Sets.icHighStakes.image,
            "pw": Asset.Sets.icPartingWords.image
        ]
        return icons[code.lowercased()] ?? Asset.Sets.icNotFound.image
    }
}
