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

final class SetDTOTests: XCTestCase {

    func test_icon() {
        let testCases: [(code: String, expectedIcon: SWDIcon)] = [
            ("aw", .icAwakenings),
            ("sor", .icSpiritOfRebellion),
            ("eaw", .icEmpireAtWar),
            ("tpg", .icTwoPlayerGame),
            ("leg", .icLegacies),
            ("riv", .icRivals),
            ("wotf", .icWayOfTheForce),
            ("atg", .icAcrossTheGalaxy),
            ("conv", .icConvergence),
            ("aon", .icAlliesOfNecessity),
            ("soh", .icSparkOfHope),
            ("cm", .icCovertMissions),
            ("tr", .icTransformations),
            ("fa", .icFalteringAllegiances),
            ("ec", .icEternalConflict),
            ("rm", .icRedemption),
            ("ap", .icAlteredPaths),
            ("pw", .icPartingWords),
            ("unknown", .icUnknown)
        ]

        for testCase in testCases {
            let setDTO = SetDTO.stub(name: "Test", code: testCase.code)
            XCTAssertEqual(setDTO.icon, testCase.expectedIcon, "Icon for code \(testCase.code) did not match expected icon.")
        }
    }
}
