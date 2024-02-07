//
//  SetsListDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsListDatasourceTests: XCTestCase {

    private var sut: SetsListDatasource!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        sut = SetsListDatasource(tableView: tableView)
        sut.sortAndSplitTableData(setList: [.stub()])
    }

    override func tearDown() {
        tableView = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is SetsTableCell)
    }

    func test_numberOfRowsInSection() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 1)
    }

    func test_getSet() {
        let set = sut.getSet(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(set)
    }

    func test_sortAndSplitTableData() {
        let setList: [SetDTO] = [
            .stub(),
            .stub(name: "Spirit of Rebellion", code: "SoR"),
            .stub(name: "Empire at War", code: "EaW"),
            .stub(name: "Spark of Hope", code: "SoH")
        ]

        sut.sortAndSplitTableData(setList: setList)

        XCTAssertEqual(sut.sections.count, 3)
        XCTAssertEqual(sut.swdSets.count, 3)
    }
}
