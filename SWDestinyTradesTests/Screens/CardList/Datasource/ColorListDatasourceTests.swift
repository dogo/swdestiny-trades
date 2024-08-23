//
//  ColorListDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class ColorListDatasourceTests: XCTestCase {

    private var tableView: UITableView!
    private var datasource: ColorListDatasource!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        datasource = ColorListDatasource(tableView: tableView)
        tableView.dataSource = datasource
    }

    override func tearDown() {
        datasource = nil
        tableView = nil
        super.tearDown()
    }

    func testNumberOfSections_NoSections_ReturnsZero() {
        let numberOfSections = datasource.numberOfSections(in: tableView)
        XCTAssertEqual(numberOfSections, 0)
    }

    func testNumberOfSections_WithSections_ReturnsCorrectCount() {
        datasource.sortByColor(cardList: createMockCardList())
        let numberOfSections = datasource.numberOfSections(in: tableView)
        XCTAssertEqual(numberOfSections, 4) // Including the inserted header section
    }

    func testNumberOfRowsInSection_NoRowsInSection_ReturnsZero() {
        datasource.sortByColor(cardList: createMockCardList())
        let numberOfRows = datasource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 0)
    }

    func testNumberOfRowsInSection_WithRowsInSection_ReturnsCorrectCount() {
        let cards = createMockCardList()
        datasource.sortByColor(cardList: cards)
        let numberOfRows = datasource.tableView(tableView, numberOfRowsInSection: 2)
        XCTAssertEqual(numberOfRows, 1)
    }

    func testCellForRowAtIndexPath_ValidIndexPath_ReturnsConfiguredCell() {
        let cards = createMockCardList()
        datasource.sortByColor(cardList: cards)
        tableView.register(CardCell.self, forCellReuseIdentifier: String(describing: CardCell.self))

        let cell = datasource.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)) as? CardCell
        XCTAssertNotNil(cell)
    }

    func testTitleForHeaderInSection_ValidSection_ReturnsCorrectTitle() {
        let cards = createMockCardList()
        datasource.sortByColor(cardList: cards)
        let title = datasource.tableView(tableView, titleForHeaderInSection: 2)
        XCTAssertEqual(title, "Gray")
    }

    func testGetCard_ValidIndexPath_ReturnsCorrectCard() {
        let cards = createMockCardList()
        datasource.sortByColor(cardList: cards)
        let card = datasource.getCard(at: IndexPath(row: 1, section: 3))
        XCTAssertNotNil(card)
        XCTAssertEqual(card?.code, "redCard2")
    }

    func testGetCardList_ReturnsAllCards() {
        let cards = createMockCardList()
        datasource.sortByColor(cardList: cards)
        let cardList = datasource.getCardList()
        XCTAssertEqual(cardList.count, cards.count)
    }

    func testSortByColor_UpdatesSectionsAndColorCards() {
        let cards = createMockCardList()
        datasource.sortByColor(cardList: cards)
        XCTAssertEqual(datasource.sections.count, 4) // 3 sections + 1 header section
        XCTAssertNotNil(datasource.colorCards["red"])
        XCTAssertEqual(datasource.colorCards["red"]?.count, 2)
    }

    private func createMockCardList() -> [CardDTO] {
        return [
            CardDTO.stub(factionCode: "red", code: "redCard1"),
            CardDTO.stub(factionCode: "red", code: "redCard2"),
            CardDTO.stub(factionCode: "blue", code: "blueCard1"),
            CardDTO.stub(factionCode: "gray", code: "grayCard1")
        ]
    }
}
