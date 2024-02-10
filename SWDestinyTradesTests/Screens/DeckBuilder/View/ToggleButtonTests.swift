//
//  ToggleButtonTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 10/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class ToggleButtonTests: XCSnapshotableTestCase {

    private var sut: ToggleButton!

    override func setUp() {
        super.setUp()
        sut = ToggleButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_initilization() {
        XCTAssertTrue(snapshot(sut, named: "ToggleButton with a valid layout"))
    }

    func test_layout_isActive_false() {
        sut.setTitle("Title", for: .normal)
        sut.isActivate = false

        XCTAssertTrue(snapshot(sut, named: "ToggleButton with a isActive true layout"))
    }

    func test_layout_isActive_true() {
        sut.setTitle("Title", for: .normal)
        sut.isActivate = true

        XCTAssertTrue(snapshot(sut, named: "ToggleButton with a isActive false layout"))
    }

    func test_buttonTouched() {
        var didCallButtonTouched = false
        sut.buttonTouched = { isActive in
            didCallButtonTouched = isActive
        }

        sut.sendActions(for: .touchUpInside)

        XCTAssertTrue(didCallButtonTouched)
    }
}
