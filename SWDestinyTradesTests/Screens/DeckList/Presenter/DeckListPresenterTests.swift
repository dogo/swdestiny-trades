//
//  DeckListPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 21/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckListPresenterTests: XCTestCase {

    private var sut: DeckListPresenter!
    private var database: RealmDatabase?
    private var navigator: DeckListNavigator!
    private var controller: DeckListViewControllerSpy!

    override func setUp() {
        super.setUp()
        controller = DeckListViewControllerSpy()
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigator = DeckListNavigator(controller.navigationController)
        sut = DeckListPresenter(controller: controller,
                                database: database,
                                navigator: navigator)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test setupNavigationItems

    func test_setupNavigationItems() {
        var expectedItem: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            expectedItem = items
        }

        XCTAssertEqual(expectedItem?.count, 1)
    }

    // MARK: - Test setNavigationTitle

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "Decks")
    }

    // MARK: - Test loadDataFromRealm

    func test_loadDataFromRealm() {
        sut.loadDataFromRealm()

        XCTAssertEqual(controller.didCallUpdateTableViewData.count, 9)
    }

    // MARK: - Test navigateToDeckBuilder

    func test_navigateToDeckBuilder() {
        sut.navigateToDeckBuilder(with: .stub())

        // XCTAssertTrue(controller.navigationController?.topViewController is CardDetailViewController)
    }
}
