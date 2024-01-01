//
//  AddCardDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardDatasourceTests: XCTestCase {

    private var sut: AddCardDatasource!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        sut = AddCardDatasource(cards: [.stub()],
                                tableView: tableView,
                                delegate: AddCardTableDelegate())
    }

    override func tearDown() {
        tableView = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is AddCardCell)
    }

    func test_numberOfRowsInSection_not_searching() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 1)
    }

    func test_numberOfRowsInSection_searching() {
        sut.doingSearch("text")

        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 0)
    }

    func test_updateSearchList() {
        sut.updateSearchList([
            .stub(),
            .stub()
        ])

        XCTAssertEqual(sut.cardsData.count, 2)
        XCTAssertEqual(sut.filtered.count, 2)
    }

    func test_getCard_not_searching() {
        let card = sut.getCard(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(card)
    }

    func test_getCard_searching() {
        sut.doingSearch("Phasma")

        let card = sut.getCard(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(card)
    }

    func test_doingSearch() {
        sut.doingSearch("Phasma")

        XCTAssertTrue(sut.searchIsActive)
    }
}
