//
//  SearchDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class SearchDatasourceTests: XCTestCase {

    private var sut: SearchDatasource!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        sut = SearchDatasource(cards: [.stub()],
                               tableView: tableView,
                               delegate: Search())
    }

    override func tearDown() {
        tableView = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is CardSearchCell)
    }

    func test_numberOfRowsInSection() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 1)
    }

    func test_updateSearchList() {
        sut.updateSearchList([.stub(), .stub()])

        XCTAssertEqual(sut.cardsData.count, 2)
    }

    func test_getCard() {
        XCTAssertNotNil(sut.getCard(at: IndexPath(row: 0, section: 0)))
    }
}
