//
//  SetsViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsViewTests: XCSnapshotableTestCase {

    private var sut: SetsView!

    override func setUp() {
        super.setUp()
        sut = SetsView(frame: .testDevice)
    }

    func testInitialization() {
        sut.updateSetList(SetDTO.stub())

        XCTAssertTrue(snapshot(sut))
    }

    func testDidSelectSet() {
        var didCallDidSelectSet = [SetDTO]()
        sut.didSelectSet = { set in
            didCallDidSelectSet.append(set)
        }

        sut.setsTableView?.didSelectSet?(.stub().first!)

        XCTAssertEqual(didCallDidSelectSet.count, 1)
        XCTAssertEqual(didCallDidSelectSet[0].name, SetDTO.stub()[0].name)
    }
}
