//
//  CardListViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardListViewTests: XCSnapshotableTestCase {

    private var sut: CardListView!

    override func setUp() {
        super.setUp()
        sut = CardListView(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_CardListView_layout() {
        sut.updateCardList([.stub()])
        XCTAssertTrue(snapshot(sut, named: "Add Card List"))
    }

    func test_startLoading() {
        sut.startLoading()

        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }

    func test_stopLoading() {
        sut.stopLoading()

        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }

    func test_updateCardList() {
        sut.updateCardList([.stub()])

        let datasourceCount = sut.cardListTableView.dataSource?.tableView(sut.cardListTableView,
                                                                          numberOfRowsInSection: 1)

        XCTAssertEqual(datasourceCount, 1)
    }

    func test_didSelectCard() {
        sut.didSelectCard = { _, _ in }

        XCTAssertNotNil(sut.cardListTableView.didSelectCard)
    }
}
