//
//  DeckListDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckListDatasourceTests: XCTestCase {

    private var sut: DeckListDatasource!
    private var delegate: DeckListPresenterSpy!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        delegate = DeckListPresenterSpy()
        sut = DeckListDatasource(tableView: tableView, delegate: delegate)
        sut.updateTableViewData(list: [.stub()])
    }

    override func tearDown() {
        tableView = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is DeckListCell)
    }

    func test_deleteRow() {
        let decks: [DeckDTO] = [
            .stub(),
            .stub()
        ]
        sut.updateTableViewData(list: decks)

        let indexPathToDelete = IndexPath(row: 0, section: 0)
        sut.tableView(tableView, commit: .delete, forRowAt: indexPathToDelete)

        XCTAssertEqual(sut.deckList.count, 1)
        XCTAssertEqual(delegate.didCallRemove.count, 1)
        XCTAssertNotNil(delegate.didCallRemove[0])
    }

    func test_rename() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DeckListCell

        cell?.accessoryButtonTouched?("Panda", DeckDTO.stub())

        XCTAssertEqual(delegate.didCallRenameValues.count, 1)
        XCTAssertEqual(delegate.didCallRenameValues[0].name, "Panda")
        XCTAssertNotNil(delegate.didCallRenameValues[0].deck)
    }

    func test_numberOfRowsInSection() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 1)
    }

    func test_getDeck() {
        let deck = sut.getDeck(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(deck)
    }

    func test_updateTableViewData() {
        sut.updateTableViewData(list: [.stub(), .stub()])

        XCTAssertEqual(sut.deckList.count, 2)
    }

    func test_insert() {
        sut.insert(deck: .stub())

        XCTAssertEqual(sut.deckList.count, 2)
        XCTAssertEqual(delegate.didCallInsert.count, 1)
        XCTAssertNotNil(delegate.didCallInsert[0])
    }
}
