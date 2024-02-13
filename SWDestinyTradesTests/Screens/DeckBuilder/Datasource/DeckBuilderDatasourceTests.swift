//
//  DeckBuilderDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class DeckBuilderDatasourceTests: XCTestCase {

    private var tableView: UITableView!
    private var delegate: DeckBuilderPresenterSpy!
    private var sut: DeckBuilderDatasource!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        delegate = DeckBuilderPresenterSpy()
        sut = DeckBuilderDatasource(tableView: tableView, delegate: delegate)
        sut.updateTableViewData(deck: .stub())
    }

    override func tearDown() {
        tableView = nil
        delegate = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is DeckBuilderCell)
    }

    func test_cellForRowAt_stepperValueChanged() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DeckBuilderCell

        cell?.stepperValueChanged?(2)

        XCTAssertEqual(delegate.didCallUpdateCardQuantity.count, 1)
        XCTAssertEqual(delegate.didCallUpdateCardQuantity[0].newValue, 2)
        XCTAssertNotNil(delegate.didCallUpdateCardQuantity[0].card)
    }

    func test_cellForRowAt_eliteButtonTouched() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DeckBuilderCell

        cell?.eliteButtonTouched?(true)

        XCTAssertEqual(delegate.didCallUpdateCharacterElite.count, 1)
        XCTAssertTrue(delegate.didCallUpdateCharacterElite[0].newValue)
        XCTAssertNotNil(delegate.didCallUpdateCharacterElite[0].card)
    }

    func test_deleteRow() {
        let cards: [CardDTO] = [
            .stub(),
            .stub()
        ]
        sut.updateTableViewData(deck: .stub(cards: cards))

        let indexPathToDelete = IndexPath(row: 0, section: 0)
        sut.tableView(tableView, commit: .delete, forRowAt: indexPathToDelete)

        XCTAssertEqual(sut.deckList.count, 1)
        XCTAssertEqual(sut.deckList[0].items.count, 1)
    }

    func test_deleteSection() {
        sut.updateTableViewData(deck: .stub(cards: [.stub()]))

        let indexPathToDelete = IndexPath(row: 0, section: 0)
        sut.tableView(tableView, commit: .delete, forRowAt: indexPathToDelete)

        XCTAssertTrue(sut.deckList.isEmpty)
    }

    func test_numberOfRowsInSection_with_collapsed_true() {
        sut.updateTableViewData(deck: .stub())

        sut.toggleSection(header: CollapsibleTableViewHeader(reuseIdentifier: #function),
                          section: 0)

        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 0)
    }

    func test_numberOfRowsInSection_with_collapsed_false() {
        sut.updateTableViewData(deck: .stub())

        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 2)
    }

    func test_getCard() {
        let set = sut.getCard(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(set)
    }

    func test_getCardList() {
        let cards = sut.getCardList()

        XCTAssertEqual(cards.count, 22)
    }

    func test_toggleSection() {
        XCTAssertFalse(sut.deckList[0].collapsed)

        sut.toggleSection(header: CollapsibleTableViewHeader(reuseIdentifier: #function),
                          section: 0)

        XCTAssertTrue(sut.deckList[0].collapsed)
    }

    func test_updateTableViewData() {
        sut.updateTableViewData(deck: .stub())

        XCTAssertEqual(sut.deckList.count, 7)
    }
}
