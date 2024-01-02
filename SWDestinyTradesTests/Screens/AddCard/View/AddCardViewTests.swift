//
//  AddCardViewTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardViewTests: XCSnapshotableTestCase {

    var sut: AddCardView!

    override func setUp() {
        super.setUp()
        sut = AddCardView(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAboutViewLayout() {
        XCTAssertTrue(snapshot(sut, named: "Add Card View"))
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

        let datasourceCount = sut.addCardTableView.tableDatasource?.tableView(sut.addCardTableView,
                                                                              numberOfRowsInSection: 0)

        XCTAssertEqual(datasourceCount, 1)
    }

    func testDoingSearch() {
        sut.doingSearch("Narf")

        let datasource = sut.addCardTableView.tableDatasource as? AddCardDatasource
        XCTAssertTrue(datasource?.searchIsActive ?? false)
    }

    func testDidSelectCardIsSet() {
        sut.didSelectCard = { _ in }

        XCTAssertNotNil(sut.addCardTableView.didSelectCard)
    }

    func testDidSelectAccessoryIsSet() {
        sut.didSelectAccessory = { _ in }

        XCTAssertNotNil(sut.addCardTableView.didSelectAccessory)
    }

    func testDoingSearchIsSet() {
        sut.doingSearch = { _ in }

        XCTAssertNotNil(sut.searchBar.doingSearch)
    }
}
