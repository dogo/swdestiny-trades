//
//  SetDTO+UtilsTest.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class SetDTOTests: XCTestCase {

    func test_icon() {
        let testCases: [(code: String, expectedIcon: UIImage)] = [
            ("aw", Asset.Sets.icAwakenings.image),
            ("sor", Asset.Sets.icSpiritOfRebellion.image),
            ("eaw", Asset.Sets.icEmpireAtWar.image),
            ("tpg", Asset.Sets.icTwoPlayerGame.image),
            ("leg", Asset.Sets.icLegacies.image),
            ("riv", Asset.Sets.icRivals.image),
            ("wotf", Asset.Sets.icWayOfTheForce.image),
            ("atg", Asset.Sets.icAcrossTheGalaxy.image),
            ("conv", Asset.Sets.icConvergence.image),
            ("aon", Asset.Sets.icAlliesOfNecessity.image),
            ("soh", Asset.Sets.icSparkOfHope.image),
            ("cm", Asset.Sets.icCovertMissions.image),
            ("tr", Asset.Sets.icTransformations.image),
            ("fa", Asset.Sets.icFalteringAllegiances.image),
            ("ec", Asset.Sets.icEternalConflict.image),
            ("rm", Asset.Sets.icRedemption.image),
            ("hs", Asset.Sets.icHighStakes.image),
            ("pw", Asset.Sets.icPartingWords.image),
            ("unknown", Asset.Sets.icNotFound.image)
        ]

        for testCase in testCases {
            let setDTO = SetDTO(name: "Test", code: testCase.code)
            XCTAssertEqual(setDTO.icon, testCase.expectedIcon, "Icon for code \(testCase.code) did not match expected icon.")
        }
    }
}
