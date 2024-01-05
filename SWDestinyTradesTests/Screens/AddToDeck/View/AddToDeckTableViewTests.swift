//
//  AddToDeckTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddToDeckTableViewTests: XCTestCase {

    private var sut: AddToDeckTableView!

    override func setUp() {
        super.setUp()
        sut = AddToDeckTableView(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testUpdateSearchList() {
        sut.updateSearchList([.stub()])

        let datasourceCount = sut.tableDatasource.tableView(sut, numberOfRowsInSection: 0)

        XCTAssertEqual(datasourceCount, 1)
    }

    func testDoingSearch() {
        sut.doingSearch("Narf")

        let datasource = sut.tableDatasource as AddToDeckCardDatasource
        XCTAssertTrue(datasource.searchIsActive)
    }

    func test_didSelectRow() {

        sut.updateSearchList([.stub()])

        var didCallDidSelectCard = 0
        var didSelectCardValue: CardDTO?
        sut.didSelectCard = { card in
            didCallDidSelectCard += 1
            didSelectCardValue = card
        }

        sut.didSelectRow(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValue)
    }

    func test_didSelectAccessory() {

        sut.updateSearchList([.stub()])

        var didCallDidSelectAccessory = 0
        var didSelectCardValue: CardDTO?
        sut.didSelectAccessory = { card in
            didCallDidSelectAccessory += 1
            didSelectCardValue = card
        }

        sut.didSelectAccessory(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectAccessory, 1)
        XCTAssertNotNil(didSelectCardValue)
    }

    func test_didSelectSegment_index_zero() {

        sut.updateSearchList([.stub()])

        var didCallDidSelectRemote = 0
        sut.didSelectRemote = {
            didCallDidSelectRemote += 1
        }

        sut.didSelectSegment(index: 0)

        let datasourceCount = sut.tableDatasource.tableView(sut, numberOfRowsInSection: 0)

        XCTAssertEqual(didCallDidSelectRemote, 1)
        XCTAssertEqual(datasourceCount, 0)
    }

    func test_didSelectSegment_index_one() {

        sut.updateSearchList([.stub()])

        var didCallDidSelectLocal = 0
        sut.didSelectLocal = {
            didCallDidSelectLocal += 1
        }

        sut.didSelectSegment(index: 1)

        let datasourceCount = sut.tableDatasource.tableView(sut, numberOfRowsInSection: 0)

        XCTAssertEqual(didCallDidSelectLocal, 1)
        XCTAssertEqual(datasourceCount, 0)
    }

    func test_didSelectSegment_index_not_found() {

        sut.updateSearchList([.stub()])

        var didCallDidSelectRemote = 0
        sut.didSelectRemote = {
            didCallDidSelectRemote += 1
        }

        var didCallDidSelectLocal = 0
        sut.didSelectLocal = {
            didCallDidSelectLocal += 1
        }

        sut.didSelectSegment(index: 3)

        let datasourceCount = sut.tableDatasource.tableView(sut, numberOfRowsInSection: 0)

        XCTAssertEqual(didCallDidSelectRemote, 0)
        XCTAssertEqual(didCallDidSelectLocal, 0)
        XCTAssertEqual(datasourceCount, 1)
    }

    func testKeyboardWillShow() {
        let keyboardSize = CGSize(width: 320, height: 216)
        let userInfo: [AnyHashable: Any] = [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: keyboardSize.width, height: keyboardSize.height))
        ]
        let notification = NSNotification(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: userInfo)

        sut.keyboardWillShow(notification: notification)

        XCTAssertEqual(sut.contentInset.bottom, keyboardSize.height)
        XCTAssertEqual(sut.verticalScrollIndicatorInsets.bottom, keyboardSize.height)
    }

    func testKeyboardWillHide() {
        let notification = NSNotification(name: UIResponder.keyboardWillHideNotification, object: nil)
        sut.keyboardWillHide(notification: notification)

        XCTAssertEqual(sut.contentInset, UIEdgeInsets.zero)
        XCTAssertEqual(sut.verticalScrollIndicatorInsets, UIEdgeInsets.zero)
    }
}
