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

    func test_fetchAllCards() async {
        sut = createSUT(type: .borrow, identifier: "testFetchAllCards")

        await sut.fetchAllCards()

        // XCTAssertEqual(view.didCallStartLoading, 1)
    }

    func test_insert_card_into_lentMe_database_successfuly() {
        sut = createSUT(person: .stub(), type: .lent, identifier: "testInsertCardIntoLentMeDatabase")

        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_insert_card_into_borrow_database_successfuly() {
        sut = createSUT(person: .stub(), type: .borrow, identifier: "testInsertCardIntoBorrowDatabase")

        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_insert_card_into_collection_database_successfuly() {
        sut = createSUT(userCollection: .stub(), type: .collection, identifier: "testInsertCardIntoCollectionDatabase")

        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_doingSearch() {
        sut = createSUT(userCollection: .stub(), type: .collection, identifier: "test_doingSearch")

        sut.doingSearch("Jabba")

        XCTAssertEqual(view.didCallDoingSearch.count, 1)
        XCTAssertEqual(view.didCallDoingSearch[0], "Jabba")
    }

    func test_cardDetailButtonTouched() {
        sut = createSUT(userCollection: .stub(), type: .collection, identifier: "test_cardDetailButtonTouched")

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
