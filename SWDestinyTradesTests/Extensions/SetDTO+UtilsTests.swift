//
//  SetDTO+UtilsTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import SwiftUI
import XCTest

@testable import SWDestinyTrades

final class SetDTOTests: BaseTestCase {

    func test_icon() {
        let testCases: [(code: String, expectedIcon: Image)] = [
            ("aw", Asset.Sets.icAwakenings.swiftUIImage),
            ("sor", Asset.Sets.icSpiritOfRebellion.swiftUIImage),
            ("eaw", Asset.Sets.icEmpireAtWar.swiftUIImage),
            ("tpg", Asset.Sets.icTwoPlayerGame.swiftUIImage),
            ("leg", Asset.Sets.icLegacies.swiftUIImage),
            ("riv", Asset.Sets.icRivals.swiftUIImage),
            ("wotf", Asset.Sets.icWayOfTheForce.swiftUIImage),
            ("atg", Asset.Sets.icAcrossTheGalaxy.swiftUIImage),
            ("conv", Asset.Sets.icConvergence.swiftUIImage),
            ("aon", Asset.Sets.icAlliesOfNecessity.swiftUIImage),
            ("soh", Asset.Sets.icSparkOfHope.swiftUIImage),
            ("cm", Asset.Sets.icCovertMissions.swiftUIImage),
            ("tr", Asset.Sets.icTransformations.swiftUIImage),
            ("fa", Asset.Sets.icFalteringAllegiances.swiftUIImage),
            ("ec", Asset.Sets.icEternalConflict.swiftUIImage),
            ("rm", Asset.Sets.icRedemption.swiftUIImage),
            ("hs", Asset.Sets.icHighStakes.swiftUIImage),
            ("pw", Asset.Sets.icPartingWords.swiftUIImage),
            ("unknown", Asset.Sets.icNotFound.swiftUIImage)
        ]

        for testCase in testCases {
            let setDTO = SetDTO.stub(name: "Test", code: testCase.code)
            XCTAssertEqual(setDTO.icon, testCase.expectedIcon, "Icon for code \(testCase.code) did not match expected icon.")
        }
    }
}
