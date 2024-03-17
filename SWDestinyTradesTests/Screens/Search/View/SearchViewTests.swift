//
//  SearchViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 17/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SearchViewTests: XCSnapshotableTestCase {

    private var sut: SearchView!

    override func setUp() {
        super.setUp()
        sut = SearchView(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_searchView_layout() {
        XCTAssertTrue(snapshot(sut, named: "Search View layout"))
    }

    func test_startLoading() {
        sut.startLoading()

        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }

    func test_stopLoading() {
        sut.stopLoading()

        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }

    func test_updateSearchList() {
        sut.updateSearchList([.stub()])

        let datasourceCount = sut.searchTableView.searchDatasource?.tableView(sut.searchTableView,
                                                                              numberOfRowsInSection: 0)

        XCTAssertEqual(datasourceCount, 1)
    }

    func test_didSelectCard_is_set() {
        sut.didSelectCard = { _ in }

        XCTAssertNotNil(sut.searchTableView.didSelectCard)
    }

    func test_doingSearch_is_set() {
        sut.doingSearch = { _ in }

        XCTAssertNotNil(sut.searchBar.doingSearch)
    }
}
