//
//  AddToDeckViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddToDeckViewTests: XCSnapshotableTestCase {

    var sut: AddToDeckView!

    override func setUp() {
        super.setUp()
        sut = AddToDeckView(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAddToDeckViewLayout() {
        XCTAssertTrue(snapshot(sut, named: "Add To Deck View"))
    }

    func testStartLoading() {
        sut.startLoading()

        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }

    func testStopLoading() {
        sut.stopLoading()

        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }

    func testUpdateSearchList() {
        sut.updateSearchList([.stub()])

        let datasourceCount = sut.addToDeckTableView.tableDatasource.tableView(sut.addToDeckTableView,
                                                                               numberOfRowsInSection: 0)

        XCTAssertEqual(datasourceCount, 1)
    }

    func testDoingSearch() {
        sut.doingSearch("Narf")

        let datasource = sut.addToDeckTableView.tableDatasource as AddToDeckCardDatasource
        XCTAssertTrue(datasource.searchIsActive)
    }

    func test_didSelectCard_is_set() {
        sut.didSelectCard = { _ in }

        XCTAssertNotNil(sut.addToDeckTableView.didSelectCard)
    }

    func test_didSelectAccessory_is_set() {
        sut.didSelectAccessory = { _ in }

        XCTAssertNotNil(sut.addToDeckTableView.didSelectAccessory)
    }

    func test_doingSearch_is_set() {
        sut.doingSearch = { _ in }

        XCTAssertNotNil(sut.searchBar.doingSearch)
    }

    func test_didSelectRemote_is_set() {
        sut.didSelectRemote = {}

        XCTAssertNotNil(sut.addToDeckTableView.didSelectRemote)
    }

    func test_didSelectLocal_is_set() {
        sut.didSelectLocal = {}

        XCTAssertNotNil(sut.addToDeckTableView.didSelectLocal)
    }
}
