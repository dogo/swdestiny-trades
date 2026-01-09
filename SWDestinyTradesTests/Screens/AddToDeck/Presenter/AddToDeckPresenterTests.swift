//
//  AddToDeckPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 04/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddToDeckPresenterTests: BaseTestCase {

    private var sut: AddToDeckPresenter!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var view: AddToDeckViewSpy!
    private var navigator: AddCardNavigator!
    private var navigationController: UINavigationControllerMock!
    private var database: RealmDatabase?
    private var taskProviderMock: TaskProviderMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewControllerMock()
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        client = DependencyManager.shared.resolve(type: HttpClientProtocol.self, mode: .shared) as? HttpClientMock
        service = SWDestinyService()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        view = AddToDeckViewSpy()
        navigator = AddCardNavigator(controller)
        taskProviderMock = TaskProviderMock()
        sut = AddToDeckPresenter(controller: view,
                                 interactor: AddToDeckInteractor(service: service),
                                 database: database,
                                 navigator: navigator,
                                 deck: .stub(),
                                 taskProvider: taskProviderMock)
    }

    override func tearDown() {
        client = nil
        service = nil
        navigationController = nil
        sut = nil
        taskProviderMock = nil
        super.tearDown()
    }

    @MainActor
    func test_retrieveAllCards() async {
        client.fileName = "card-list"
        sut.retrieveAllCards()
        await taskProviderMock.waitForTasks()
        XCTAssertEqual(view.didCallStartLoading, 1)
        XCTAssertEqual(view.didCallStopLoading, 1)
        XCTAssertEqual(view.didCallUpdateSearchList.count, 22)
    }

    @MainActor
    func test_retrieveAllCards_failing() async {
        client.error = true
        sut.retrieveAllCards()
        await taskProviderMock.waitForTasks()
        XCTAssertEqual(view.didCallStartLoading, 1)
        XCTAssertEqual(view.didCallStopLoading, 1)
        // XCTAssertEqual(view.didCallShowNetworkErrorMessage, 1)
    }

    func test_insert_card_into_deck_database_successfuly() {
        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
    }

    func test_insert_card_does_not_insert_into_deck_database() {
        sut.insert(card: .stub())
        sut.insert(card: .stub())

        XCTAssertEqual(view.didCallShowSuccessMessage.count, 1)
        // XCTAssertEqual(view.didCallShowErrorMessage, 1)
    }

    func test_doingSearch() {
        sut.doingSearch("Jabba")

        XCTAssertEqual(view.didCallDoingSearch.count, 1)
        XCTAssertEqual(view.didCallDoingSearch[0], "Jabba")
    }

    func test_loadDataFromRealm() {
        let userCollection = UserCollectionDTO()
        try? database?.save(object: userCollection, completion: nil)

        sut.loadDataFromRealm()

        // XCTAssertEqual(view.didCallUpdateSearchList.count, 1)
    }

    func test_navigateToCardDetail() {
        sut.navigateToCardDetail(with: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }
}
