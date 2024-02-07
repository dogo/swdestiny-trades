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

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_initialization() {
        let sets: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]
        sut.updateSetList(sets)

        XCTAssertTrue(snapshot(sut))
    }

    func test_didSelectSet() {
        var didCallDidSelectSet = [SetDTO]()
        sut.didSelectSet = { set in
            didCallDidSelectSet.append(set)
        }

        sut.setsTableView?.didSelectSet?(.stub())

        XCTAssertEqual(didCallDidSelectSet.count, 1)
        XCTAssertEqual(didCallDidSelectSet[0].name, SetDTO.stub().name)
    }
    
    func test_setupPullToRefresh() {
        // sut.setupPullToRefresh(target: Any, action: Selector)
    }
}
