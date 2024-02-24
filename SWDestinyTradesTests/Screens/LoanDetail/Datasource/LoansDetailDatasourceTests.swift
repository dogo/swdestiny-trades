//
//  LoansDetailDatasourceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class LoansDetailDatasourceTests: XCTestCase {

    private var sut: LoansDetailDatasource!
    private var delegate: LoansDetailsPresenterSpy!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        delegate = LoansDetailsPresenterSpy()
        sut = LoansDetailDatasource(tableView: tableView, delegate: delegate)

        let cards: [CardDTO] = [
            .stub(),
            .stub()
        ]

        sut.updateTableViewData(person: .stub(lentMe: cards,
                                              borrowed: cards))
    }

    override func tearDown() {
        tableView = nil
        sut = nil
        super.tearDown()
    }

    func test_cellForRowAt_with_section_zero() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is LoanDetailCell)
    }

    func test_cellForRowAt_for_configure_add_card_to_lentMe() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0))

        XCTAssertTrue(cell is LoanDetailCell)
    }

    func test_cellForRowAt_with_section_one() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))

        XCTAssertTrue(cell is LoanDetailCell)
    }

    func test_cellForRowAt_for_configure_add_card_to_borrow() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 1))

        XCTAssertTrue(cell is LoanDetailCell)
    }

    func test_stepperValueChanged_for_lentMe_cards() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? LoanDetailCell
        cell?.stepperValueChanged?(4)

        XCTAssertEqual(delegate.didCallStepperValueChangedValues.count, 1)
        XCTAssertEqual(delegate.didCallStepperValueChangedValues[0].newValue, 4)
        XCTAssertNotNil(delegate.didCallStepperValueChangedValues[0].card)
    }

    func test_stepperValueChanged_for_bowrrow_cards() {
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? LoanDetailCell
        cell?.stepperValueChanged?(4)

        XCTAssertEqual(delegate.didCallStepperValueChangedValues.count, 1)
        XCTAssertEqual(delegate.didCallStepperValueChangedValues[0].newValue, 4)
        XCTAssertNotNil(delegate.didCallStepperValueChangedValues[0].card)
    }

    func test_titleForHeaderInSectiont_with_section_zero() {
        let title = sut.tableView(tableView, titleForHeaderInSection: 0)

        XCTAssertEqual(title, "Has lent me:")
    }

    func test_titleForHeaderInSectiont_with_section_one() {
        let title = sut.tableView(tableView, titleForHeaderInSection: 1)

        XCTAssertEqual(title, "Has borrowed my:")
    }

    func test_deleteRow_from_section_zero() {
        XCTAssertEqual(sut.lentMe.count, 2)

        let indexPathToDelete = IndexPath(row: 0, section: 0)
        sut.tableView(tableView, commit: .delete, forRowAt: indexPathToDelete)

        XCTAssertEqual(sut.lentMe.count, 1)
        XCTAssertEqual(delegate.didCallRemoveValues.count, 1)
        XCTAssertEqual(delegate.didCallRemoveValues[0].index, 0)
        XCTAssertEqual(delegate.didCallRemoveValues[0].section, .lent)
    }

    func test_deleteRow_from_section_one() {
        XCTAssertEqual(sut.borrowed.count, 2)

        let indexPathToDelete = IndexPath(row: 0, section: 1)
        sut.tableView(tableView, commit: .delete, forRowAt: indexPathToDelete)

        XCTAssertEqual(sut.borrowed.count, 1)
        XCTAssertEqual(delegate.didCallRemoveValues.count, 1)
        XCTAssertEqual(delegate.didCallRemoveValues[0].index, 0)
        XCTAssertEqual(delegate.didCallRemoveValues[0].section, .borrow)
    }

    func test_canEditRowAt_from_section_zero() {
        let indexPathToEdit = IndexPath(row: 2, section: 0)
        let canEditRowAt = sut.tableView(tableView, canEditRowAt: indexPathToEdit)

        XCTAssertFalse(canEditRowAt)
    }

    func test_canEditRowAt_from_section_one() {
        let indexPathToEdit = IndexPath(row: 2, section: 1)
        let canEditRowAt = sut.tableView(tableView, canEditRowAt: indexPathToEdit)

        XCTAssertFalse(canEditRowAt)
    }

    func test_canEditRowAt_from_any_section() {
        let indexPathToEdit = IndexPath(row: 0, section: 0)
        let canEditRowAt = sut.tableView(tableView, canEditRowAt: indexPathToEdit)

        XCTAssertTrue(canEditRowAt)
    }

    func test_numberOfSections() {
        XCTAssertEqual(sut.numberOfSections(in: tableView), 2)
    }

    func test_numberOfRowsInSection_zero() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 3)
    }

    func test_numberOfRowsInSection_one() {
        let rows = sut.tableView(tableView, numberOfRowsInSection: 1)

        XCTAssertEqual(rows, 3)
    }

    func test_getLentMeCards() {
        XCTAssertNotNil(sut.getLentMeCards())
    }

    func test_getBorrowedCards() {
        XCTAssertNotNil(sut.getBorrowedCards())
    }

    func test_getCard_with_section_zero() {
        let card = sut.getCard(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(card)
    }

    func test_getCard_with_section_one() {
        let card = sut.getCard(at: IndexPath(row: 0, section: 1))

        XCTAssertNotNil(card)
    }

    func test_updateTableViewData() {
        let cards: [CardDTO] = [
            .stub(),
            .stub()
        ]

        sut.updateTableViewData(person: .stub(lentMe: cards,
                                              borrowed: cards))

        XCTAssertEqual(sut.lentMe.count, 2)
        XCTAssertEqual(sut.borrowed.count, 2)
    }
}
