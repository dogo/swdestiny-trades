//
//  AddCardTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardTableViewTests: XCTestCase {

    private var sut: AddCardTableView!
    private var datasource: AddCardDatasourceSpy!

    override func setUp() {
        super.setUp()
        datasource = AddCardDatasourceSpy()
        sut = AddCardTableView(frame: .testDevice, style: .plain)
        sut.tableDatasource = datasource
    }

    override func tearDown() {
        datasource = nil
        sut = nil
        super.tearDown()
    }

    func testDoingSearch() {
        sut.doingSearch("Narf")

        XCTAssertEqual(datasource.didCallDoingSearch.count, 1)
        XCTAssertEqual(datasource.didCallDoingSearch[0], "Narf")
    }

    func testUpdateSearchList() {
        let expectedResult = CardDTO.stub()
        sut.updateSearchList([expectedResult])

        XCTAssertEqual(datasource.didCallUpdateSearchList.count, 1)
        XCTAssertEqual(datasource.didCallUpdateSearchList[0], expectedResult)
    }

    func testDidSelectRow() {

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

    func testDidSelectAccessory() {

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
