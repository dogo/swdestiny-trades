//
//  UserCollectionDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class UserCollectionDatasourceTests: XCTestCase {

    private var sut: UserCollectionDatasource!
    private var delegate: UserCollectionPresenterSpy!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        delegate = UserCollectionPresenterSpy()
        sut = UserCollectionDatasource(tableView: tableView, delegate: delegate)
        sut.updateTableViewData(collection: .stub(collection: [.stub(), .stub()]))
    }

    override func tearDown() {
        tableView = nil
        delegate = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is LoanDetailCell)
    }

    func test_deleteRow() {
        XCTAssertEqual(sut.collectionList?.count, 2)

        let indexPathToDelete = IndexPath(row: 0, section: 0)
        sut.tableView(tableView, commit: .delete, forRowAt: indexPathToDelete)

        XCTAssertEqual(sut.collectionList?.count, 1)
        XCTAssertEqual(delegate.didCallRemoveAtIndex.count, 1)
        XCTAssertNotNil(delegate.didCallRemoveAtIndex[0])
    }

    func test_numberOfRowsInSection() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 2)
    }

    func test_getCard() {
        let card = sut.getCard(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(card)
    }

    func test_getCardList() {
        let cardList = sut.getCardList()

        XCTAssertEqual(cardList.count, 2)
    }

    func test_updateTableViewData() {
        let cardList: [CardDTO] = [
            .stub(),
            .stub(),
            .stub(),
            .stub()
        ]

        sut.updateTableViewData(collection: .stub(collection: cardList))

        XCTAssertEqual(sut.collectionList?.count, 4)
    }

    func test_sortAlphabetically() {
        let unsortedCards: [CardDTO] = [
            .stub(name: "Card B"),
            .stub(name: "Card A")
        ]

        sut.updateTableViewData(collection: .stub(collection: unsortedCards))

        sut.sortAlphabetically()

        XCTAssertEqual(sut.collectionList?[0].name, "Card A")
        XCTAssertEqual(sut.collectionList?[1].name, "Card B")
    }

    func test_sortNumerically() {
        let unsortedCards: [CardDTO] = [
            .stub(code: "002", name: "Card B"),
            .stub(code: "001", name: "Card A")
        ]

        sut.updateTableViewData(collection: .stub(collection: unsortedCards))

        sut.sortNumerically()

        XCTAssertEqual(sut.collectionList?[0].code, "001")
        XCTAssertEqual(sut.collectionList?[1].code, "002")
    }

    func test_sortByColor() {
        let unsortedCards: [CardDTO] = [
            .stub(factionCode: "red"),
            .stub(factionCode: "blue")
        ]

        sut.updateTableViewData(collection: .stub(collection: unsortedCards))

        sut.sortByColor()

        XCTAssertEqual(sut.collectionList?[0].factionCode, "blue")
        XCTAssertEqual(sut.collectionList?[1].factionCode, "red")
    }
}
