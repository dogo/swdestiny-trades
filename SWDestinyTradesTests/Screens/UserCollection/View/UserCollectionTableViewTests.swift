//
//  UserCollectionTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 21/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class UserCollectionTableViewTests: XCTestCase {

    private var sut: UserCollectionTableView!
    private var delegate: PeopleListPresenterSpy!

    override func setUp() {
        super.setUp()
        delegate = PeopleListPresenterSpy()
        sut = UserCollectionTableView(frame: .testDevice)
        sut.updateTableViewData(collection: .stub(collection: [.stub()]))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_updateTableViewData() {
        sut.updateTableViewData(collection: .stub(collection: [.stub(), .stub()]))

        XCTAssertEqual(sut.tableViewDatasource?.collectionList?.count, 2)
    }

    func test_getCardList() {
        let cardList = sut.getCardList()

        XCTAssertEqual(cardList?.count, 1)
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

    func test_sort_alphabetically() {
        let unsortedCards: [CardDTO] = [
            .stub(name: "Card B"),
            .stub(name: "Card A")
        ]

        sut.updateTableViewData(collection: .stub(collection: unsortedCards))

        sut.sort(0)

        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].name, "Card A")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].name, "Card B")
    }

    func test_sort_numerically() {
        let unsortedCards: [CardDTO] = [
            .stub(code: "002", name: "Card B"),
            .stub(code: "001", name: "Card A")
        ]

        sut.updateTableViewData(collection: .stub(collection: unsortedCards))

        sut.sort(1)

        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].code, "001")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].code, "002")
    }

    func test_sort_byColor() {
        let unsortedCards: [CardDTO] = [
            .stub(factionCode: "red"),
            .stub(factionCode: "blue")
        ]

        sut.updateTableViewData(collection: .stub(collection: unsortedCards))

        sut.sort(2)

        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].factionCode, "blue")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].factionCode, "red")
    }

    func test_sort_wrong_index() {
        let unsortedCards: [CardDTO] = [
            .stub(factionCode: "red",
                  code: "002",
                  name: "Card B"),
            .stub(factionCode: "blue",
                  code: "001",
                  name: "Card A")
        ]

        sut.updateTableViewData(collection: .stub(collection: unsortedCards))

        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].name, "Card B")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].name, "Card A")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].factionCode, "red")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].factionCode, "blue")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].code, "002")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].code, "001")

        sut.sort(3)

        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].name, "Card B")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].name, "Card A")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].factionCode, "red")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].factionCode, "blue")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[0].code, "002")
        XCTAssertEqual(sut.tableViewDatasource?.collectionList?[1].code, "001")
    }

    func test_heightForRowAt() {
        let height = sut.tableView(UITableView(), heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
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
}
