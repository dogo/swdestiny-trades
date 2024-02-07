//
//  SetsTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsTableViewTests: XCTestCase {

    private var sut: SetsTableView!

    override func setUp() {
        super.setUp()
        sut = SetsTableView(frame: .testDevice)
        sut.updateSetList([.stub()])
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_updateSetList() {
        let sets: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]
        sut.updateSetList(sets)

        XCTAssertEqual(sut.tableViewDatasource?.swdSets.count, 3)
        XCTAssertEqual(sut.tableViewDatasource?.sections.count, 3)
    }

    func test_didSelectRowAt() {

        var didCallDidSelectSet = 0
        var didSelectSetValue: SetDTO?
        sut.didSelectSet = { set in
            didCallDidSelectSet += 1
            didSelectSetValue = set
        }

        sut.didSelectRowAt(index: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectSet, 1)
        XCTAssertNotNil(didSelectSetValue)
    }

    func test_heightForRowAt() {
        let height = sut.tableView(sut, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
    }

    func test_delegate_didSelectRowAt() {
        var didCallDidSelectSet = 0
        var didSelectSetValue: SetDTO?
        sut.didSelectSet = { set in
            didCallDidSelectSet += 1
            didSelectSetValue = set
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectSet, 1)
        XCTAssertNotNil(didSelectSetValue)
    }
}
