//
//  DeckBuilderTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 09/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckBuilderTableViewTests: XCSnapshotableTestCase {

    private var sut: DeckBuilderTableView!

    override func setUp() {
        super.setUp()
        sut = DeckBuilderTableView(frame: .testDevice)
        sut.updateTableViewData(deck: .stub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_updateTableViewData() {
        sut.updateTableViewData(deck: .stub())

        XCTAssertEqual(sut.tableViewDatasource.deckList.count, 5)
    }

    func test_getDeckList() {
        let deckList = sut.getDeckList()

        XCTAssertEqual(deckList?.count, 5)
    }

    func test_didSelectRowAt() {

        var didCallDidSelectCard = 0
        var didSelectCardValues: [(cardList: [CardDTO], card: CardDTO)] = []
        sut.didSelectCard = { cardList, card in
            didCallDidSelectCard += 1
            didSelectCardValues.append((cardList, card))
        }

        sut.didSelectRowAt(index: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValues[0].cardList)
        XCTAssertNotNil(didSelectCardValues[0].card)
    }

    func test_toggleSection() {
        sut.toggleSection(header: CollapsibleTableViewHeader(frame: .zero), section: 0)

        XCTAssertTrue(sut.tableViewDatasource.deckList[0].collapsed)
    }

    func test_heightForRowAt() {
        let height = sut.tableView(sut, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
    }

    func test_heightForRowAt_with_section_collapsed() {
        sut.toggleSection(header: CollapsibleTableViewHeader(frame: .zero), section: 0)

        let height = sut.tableView(sut, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 0)
    }

    func test_heightForRowAt_when_the_datasource_is_nil() {
        sut = DeckBuilderTableView(frame: .testDevice)

        let height = sut.tableView(sut, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 0)
    }

    func test_delegate_didSelectRowAt() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [(cardList: [CardDTO], card: CardDTO)] = []
        sut.didSelectCard = { cardList, card in
            didCallDidSelectCard += 1
            didSelectCardValues.append((cardList, card))
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValues[0].cardList)
        XCTAssertNotNil(didSelectCardValues[0].card)
    }

    func test_viewForHeaderInSection() {
        sut.register(headerFooterViewType: CollapsibleTableViewHeader.self)

        let header = sut.tableView(sut, viewForHeaderInSection: 0)

        XCTAssertNotNil(header)
    }

    func test_heightForHeaderInSection() {
        let height = sut.tableView(sut, heightForHeaderInSection: 0)

        XCTAssertEqual(height, 44)
    }
}
