//
//  LoanDetailTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class LoanDetailTableViewTests: XCTestCase {

    private var sut: LoanDetailTableView!
    private var delegate: LoansDetailsPresenterSpy!

    override func setUp() {
        super.setUp()
        delegate = LoansDetailsPresenterSpy()
        sut = LoanDetailTableView(frame: .testDevice, delegate: delegate)
        let cards: [CardDTO] = [
            .stub(),
            .stub()
        ]

        sut.updateTableViewData(person: .stub(lentMe: cards,
                                              borrowed: cards))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_updateTableViewData() {
        let cards: [CardDTO] = [
            .stub(),
            .stub()
        ]

        sut.updateTableViewData(person: .stub(lentMe: cards,
                                              borrowed: cards))

        XCTAssertEqual(sut.tableViewDatasource.lentMe.count, 2)
        XCTAssertEqual(sut.tableViewDatasource.borrowed.count, 2)
    }

    func test_didSelectRowAt_card_lentMe_index() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [(CardDTO, AddCardType)] = []
        sut.didSelectCard = { card, type in
            didCallDidSelectCard += 1
            didSelectCardValues.append((card, type))
        }

        sut.didSelectRowAt(index: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValues[0].0)
        XCTAssertEqual(didSelectCardValues[0].1, .lent)
    }

    func test_didSelectRowAt_card_borrow_index() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [(CardDTO, AddCardType)] = []
        sut.didSelectCard = { card, type in
            didCallDidSelectCard += 1
            didSelectCardValues.append((card, type))
        }

        sut.didSelectRowAt(index: IndexPath(row: 0, section: 1))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValues[0].0)
        XCTAssertEqual(didSelectCardValues[0].1, .borrow)
    }

    func test_didSelectRowAt_add_card_to_lentMe() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [AddCardType] = []
        sut.didSelectAddItem = { type in
            didCallDidSelectCard += 1
            didSelectCardValues.append(type)
        }

        sut.didSelectRowAt(index: IndexPath(row: 2, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertEqual(didSelectCardValues[0], .lent)
    }

    func test_didSelectRowAt_add_card_to_borrow() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [AddCardType] = []
        sut.didSelectAddItem = { type in
            didCallDidSelectCard += 1
            didSelectCardValues.append(type)
        }

        sut.didSelectRowAt(index: IndexPath(row: 2, section: 1))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertEqual(didSelectCardValues[0], .borrow)
    }

    func test_heightForRowAt() {
        let height = sut.tableView(sut, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
    }

    func test_delegate_didSelectRowAt_card_to_lentMe() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [(CardDTO, AddCardType)] = []
        sut.didSelectCard = { card, type in
            didCallDidSelectCard += 1
            didSelectCardValues.append((card, type))
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValues[0].0)
        XCTAssertEqual(didSelectCardValues[0].1, .lent)
    }

    func test_delegate_didSelectRowAt_card_to_borrow() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [(CardDTO, AddCardType)] = []
        sut.didSelectCard = { card, type in
            didCallDidSelectCard += 1
            didSelectCardValues.append((card, type))
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 0, section: 1))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValues[0].0)
        XCTAssertEqual(didSelectCardValues[0].1, .borrow)
    }

    func test_delegate_didSelectRowAt_add_card_to_lentMe() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [AddCardType] = []
        sut.didSelectAddItem = { type in
            didCallDidSelectCard += 1
            didSelectCardValues.append(type)
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 2, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertEqual(didSelectCardValues[0], .lent)
    }

    func test_delegate_didSelectRowAt_add_card_to_borrow() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [AddCardType] = []
        sut.didSelectAddItem = { type in
            didCallDidSelectCard += 1
            didSelectCardValues.append(type)
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 2, section: 1))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertEqual(didSelectCardValues[0], .borrow)
    }
}
