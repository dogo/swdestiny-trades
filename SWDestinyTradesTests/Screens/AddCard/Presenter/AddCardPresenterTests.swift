//
//  AddCardPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 31/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardPresenterTests: XCTestCase {

    private var sut: AddCardPresenter!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var view: AddCardViewSpy!
    private var navigator: AddCardNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewControllerMock()
        client = HttpClientMock()
        service = SWDestinyService(client: client)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        view = AddCardViewSpy()
        navigator = AddCardNavigator(controller)
    }

    override func tearDown() {
        client = nil
        service = nil
        navigationController = nil
        view = nil
        navigator = nil
        sut = nil
        super.tearDown()
    }

    @MainActor
    func test_fetchAllCards_successfully() async {
        sut = createSUT(type: .borrow, identifier: #function)

        sut.fetchAllCards()

        XCTAssertEqual(view.didCallStartLoading, 1)
        // XCTAssertEqual(view.didCallStopLoading, 1)
        // XCTAssertEqual(view.didCallUpdateSearchList.count, 1)
    }

    @MainActor
    func test_fetchAllCards_failing() async {
        sut = createSUT(type: .borrow, identifier: #function)

        client.error = true
        sut.fetchAllCards()

        XCTAssertEqual(view.didCallStartLoading, 1)
        // XCTAssertEqual(view.didCallStopLoading, 1)
        // XCTAssertEqual(view.didCallShowNetworkErrorMessage, 1)
    }

    func test_insert_card_into_lentMe_database_successfully() {
        sut = createSUT(person: .stub(), type: .lent, identifier: #function)

        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_insert_card_does_not_insert_into_lentMe_database() {
        sut = createSUT(person: .stub(), type: .lent, identifier: #function)

        sut.insert(card: .stub())
        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
        XCTAssertEqual(view.didCallShowErrorMessage, 1)
    }

    func test_insert_card_into_borrow_database_successfuly() {
        sut = createSUT(person: .stub(), type: .borrow, identifier: #function)

        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_insert_card_does_not_insert_into_borrow_database() {
        sut = createSUT(person: .stub(), type: .borrow, identifier: #function)

        sut.insert(card: .stub())
        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
        XCTAssertEqual(view.didCallShowErrorMessage, 1)
    }

    func test_insert_card_into_collection_database_successfuly() {
        sut = createSUT(userCollection: .stub(), type: .collection, identifier: #function)

        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_insert_card_does_not_insert_into_collection_database() {
        sut = createSUT(userCollection: .stub(), type: .collection, identifier: #function)

        sut.insert(card: .stub())
        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
        XCTAssertEqual(view.didCallShowErrorMessage, 1)
    }

    func test_doingSearch() {
        sut = createSUT(userCollection: .stub(), type: .collection, identifier: #function)

        sut.doingSearch("Jabba")

        XCTAssertEqual(view.didCallDoingSearch.count, 1)
        XCTAssertEqual(view.didCallDoingSearch[0], "Jabba")
    }

    func test_cardDetailButtonTouched() {
        sut = createSUT(userCollection: .stub(), type: .collection, identifier: #function)

        sut.cardDetailButtonTouched(with: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    // MARK: - Helper

    private func createSUT(person: PersonDTO? = nil,
                           userCollection: UserCollectionDTO? = nil,
                           type: AddCardType,
                           identifier: String) -> AddCardPresenter {
        return AddCardPresenter(view: view,
                                interactor: AddCardInteractor(service: service),
                                database: RealmDatabaseHelper.createMemoryDatabase(identifier: identifier),
                                navigator: navigator,
                                viewModel: .stub(person: person, userCollection: userCollection, type: type))
    }
}
