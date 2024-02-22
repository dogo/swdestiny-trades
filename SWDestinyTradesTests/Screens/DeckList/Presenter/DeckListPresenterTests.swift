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
    private var navigationController: UINavigationControllerMock!
    private var navigator: DeckListNavigator!
    private var controller: DeckListViewControllerSpy!

    override func setUp() {
        super.setUp()
        controller = DeckListViewControllerSpy()
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        navigator = DeckListNavigator(controller)
        sut = DeckListPresenter(controller: controller,
                                database: database,
                                navigator: navigator)
    }

    override func tearDown() {
        controller = nil
        database = nil
        navigator = nil
        navigationController = nil
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

        XCTAssertEqual(controller.didCallUpdateTableViewData.count, 11)
    }

    // MARK: - Test navigateToDeckBuilder

    func test_navigateToDeckBuilder() {
        sut.navigateToDeckBuilder(with: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is DeckBuilderViewController)
    }

    // MARK: - Test addButtonTouched

    func test_addButtonTouched() {

        XCTAssertEqual(countObjects(DeckDTO.self), 9)

        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let addButton = barButtonItems?[0]
        _ = addButton?.target?.perform(addButton!.action, with: nil)

        XCTAssertEqual(countObjects(DeckDTO.self), 10)
    }

    // MARK: - Test insert

    func test_insert() {
        let predicate = NSPredicate(format: "name == %@", "Insert Test")

        let deck = DeckDTO()
        deck.name = "Insert Test"

        XCTAssertNil(findObject(DeckDTO.self, predicate: predicate))

        sut.insert(deck: deck)

        XCTAssertNotNil(findObject(DeckDTO.self, predicate: predicate))
    }

    // MARK: - Test remove

    func test_remove() {
        let predicate = NSPredicate(format: "name == %@", "Remove Test")

        let deck = DeckDTO()
        deck.name = "Remove Test"

        sut.insert(deck: deck)

        XCTAssertNotNil(findObject(DeckDTO.self, predicate: predicate))

        sut.remove(deck: deck)

        XCTAssertNil(findObject(DeckDTO.self, predicate: predicate))
    }

    // MARK: - Test rename

    func test_rename() {
        let deck = DeckDTO.stub()
        XCTAssertEqual(deck.name, "Mock Deck")

        sut.rename(name: "New Name", deck: deck)

        XCTAssertEqual(deck.name, "New Name")
    }

    // MARK: - Utils

    private func findObject<T: Storable>(_ model: T.Type, predicate: NSPredicate?) -> T? {
        var foundObject: T?

        try? database?.fetch(model, predicate: predicate, sorted: nil) { results in
            foundObject = results.first
        }

        return foundObject
    }

    private func countObjects(_ model: (some Storable).Type) -> Int {
        var objectCount = 0

        try? database?.fetch(model, predicate: nil, sorted: nil) { results in
            objectCount = results.count
        }

        return objectCount
    }
}
