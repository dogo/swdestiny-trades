//
//  CardDetailPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardDetailPresenterTests: XCTestCase {

    private var sut: CardDetailPresenter!
    private var view: CardViewSpy!
    private var database: RealmDatabase?

    override func setUp() {
        super.setUp()
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        view = CardViewSpy()
        sut = CardDetailPresenter(view: view,
                                  database: database,
                                  cardList: [
                                      .stub(),
                                      .stub()
                                  ],
                                  selected: .stub())
    }

    override func tearDown() {
        database = nil
        view = nil
        sut = nil
        super.tearDown()
    }

    func test_viewDidLoadw() {
        sut.viewDidLoad()

        XCTAssertEqual(view.didCallSetSlideshowImageInputs.count, 2)
        XCTAssertEqual(view.didCallSetCurrentPage.count, 0)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(view.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(view.didCallSetNavigationTitle[0], "Captain Phasma")
    }

    func test_setupNavigationItems() {
        var expectedItem: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            expectedItem = items
        }

        XCTAssertEqual(expectedItem?.count, 2)
    }
}
