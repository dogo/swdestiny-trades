//
//  SearchTableViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 09/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SearchTableViewTests: XCTestCase {

    private var sut: SearchTableView!
    private var delegate: PeopleListPresenterSpy!

    override func setUp() {
        super.setUp()
        delegate = PeopleListPresenterSpy()
        sut = SearchTableView(frame: .testDevice)
        sut.updateSearchList([.stub()])
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_updateSearchList() {
        sut.updateSearchList([.stub(), .stub()])

        XCTAssertEqual(sut.searchDatasource?.cardsData.count, 2)
    }

    func test_didSelectRowAt() {
        var didCallDidSelectCard = 0
        var didSelectCardValues: [CardDTO] = []
        sut.didSelectCard = { card in
            didCallDidSelectCard += 1
            didSelectCardValues.append(card)
        }

        sut.didSelectRow(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(didCallDidSelectCard, 1)
        XCTAssertNotNil(didSelectCardValues[0])
    }

    func test_keyboardWillShow() {
        let keyboardSize = CGSize(width: 320, height: 216)
        let userInfo: [AnyHashable: Any] = [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: keyboardSize.width, height: keyboardSize.height))
        ]

        NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: userInfo)

        XCTAssertEqual(sut.contentInset.bottom, keyboardSize.height)
        XCTAssertEqual(sut.verticalScrollIndicatorInsets.bottom, keyboardSize.height)
    }

    func test_keyboardWillHide() {
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil, userInfo: nil)

        XCTAssertEqual(sut.contentInset, UIEdgeInsets.zero)
        XCTAssertEqual(sut.verticalScrollIndicatorInsets, UIEdgeInsets.zero)
    }
}
