//
//  DeckListTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckListTableViewTests: XCTestCase {

    private var sut: DeckListTableView!

    override func setUp() {
        super.setUp()
        sut = DeckListTableView(frame: .testDevice)
        sut.updateTableViewData(decksList: [.stub()])
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_updateTableViewData() {
        sut.updateTableViewData(decksList: [.stub()])

        XCTAssertEqual(sut.tableViewDatasource?.deckList.count, 1)
    }

    func test_insert() {
        sut.insert(deck: .stub())

        XCTAssertEqual(sut.tableViewDatasource?.deckList.count, 2)
    }

    func test_didSelectRowAt() {
        var didCallDidSelectDeck = 0
        var didSelectDeckValues: [DeckDTO] = []
        sut.didSelectDeck = { deck in
            didCallDidSelectDeck += 1
            didSelectDeckValues.append(deck)
        }

        sut.didSelectRowAt(index: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectDeck, 1)
        XCTAssertNotNil(didSelectDeckValues[0])
    }

    func test_heightForRowAt() {
        let height = sut.tableView(sut, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
    }

    func test_delegate_didSelectRowAt() {
        var didCallDidSelectDeck = 0
        var didSelectDeckValues: [DeckDTO] = []
        sut.didSelectDeck = { deck in
            didCallDidSelectDeck += 1
            didSelectDeckValues.append(deck)
        }

        sut.tableView(sut, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectDeck, 1)
        XCTAssertNotNil(didSelectDeckValues[0])
    }

    func test_keyboardWillShow() {
        let keyboardSize = CGSize(width: 320, height: 216)
        let userInfo: [AnyHashable: Any] = [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: keyboardSize.width, height: keyboardSize.height))
        ]

        NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: userInfo)

        XCTAssertEqual(sut.contentInset.bottom, 216)
        XCTAssertEqual(sut.verticalScrollIndicatorInsets.bottom, 216)
    }

    func test_keyboardWillHide() {
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil, userInfo: nil)

        XCTAssertEqual(sut.contentInset, UIEdgeInsets.zero)
        XCTAssertEqual(sut.verticalScrollIndicatorInsets, UIEdgeInsets.zero)
    }
}
