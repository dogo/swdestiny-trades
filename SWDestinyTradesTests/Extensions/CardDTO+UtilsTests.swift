//
//  CardDTO+UtilsTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class CardDTOTests: XCTestCase {

    func test_factionColor() {
        let testCases: [(factionCode: String, expectedColor: UIColor)] = [
            ("red", ColorPalette.red),
            ("yellow", ColorPalette.yellow),
            ("blue", ColorPalette.blue),
            ("gray", ColorPalette.gray),
            ("unknown", UIColor.clear)
        ]

        for testCase in testCases {
            let cardDTO = CardDTO.stub(factionCode: testCase.factionCode)
            XCTAssertEqual(cardDTO.factionColor(), testCase.expectedColor, "Faction color for code \(testCase.factionCode) did not match expected color.")
        }
    }
}
