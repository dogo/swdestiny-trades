//
//  AddCardViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 14/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import PKHUD
@testable import SWDestinyTrades
@testable import SwiftMessages

final class AddCardViewControllerTests: XCTestCase {

    private var sut: AddCardViewController!
    private var view: AddCardViewSpy!
    private var database: DatabaseProtocol!
    private var service: SWDestinyService!
    private var keyWindow: UIWindow!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: "UserCollection")
        service = SWDestinyService(client: HttpClientMock())
        view = AddCardViewSpy()
        sut = createSUT(database: database, person: .stub(), userCollection: .stub(), type: .collection)
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        database = nil
        service = nil
        view = nil
        navigationController = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_navigation_title() {
        sut.viewWillAppear(false)
        XCTAssertEqual(sut.navigationItem.title, L10n.addCard)
    }

    func testloadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is AddCardViewType)
    }

    func test_didSelectCard_inserts_into_collection_database() {
        let collection = UserCollectionDTO.stub()
        sut = createSUT(database: database, person: .stub(), userCollection: collection, type: .collection)
        let navigationController = UINavigationController(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)

        sut.viewDidLoad()
        view.didSelectCard?(.stub())

        XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func test_didSelectAccessory() {
        sut.viewDidLoad()
        view.didSelectAccessory?(.stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    func test_startLoading() {
        sut.startLoading()

        XCTAssertEqual(view.didCallStartLoading, 1)
    }

    func test_stopLoading() {
        sut.stopLoading()

        XCTAssertEqual(view.didCallStopLoading, 1)
    }

    func test_updateSearchList() {
        let expectedResult = CardDTO.stub()
        sut.updateSearchList([expectedResult])

        XCTAssertEqual(view.didCallUpdateSearchList.count, 1)
        XCTAssertEqual(view.didCallUpdateSearchList[0], expectedResult)
    }

    func test_doingSearch() {
        sut.viewDidLoad()
        view.doingSearch?("jabba")

        XCTAssertEqual(view.didCallDoingSearch.count, 1)
        XCTAssertEqual(view.didCallDoingSearch[0], "jabba")
    }

    func test_showSuccessMessage() {
        sut.showSuccessMessage(card: .stub())

        XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func test_showErrorMessage() {
        sut.showErrorMessage()

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func test_showNetworkErrorMessage() {
        sut.showNetworkErrorMessage()

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    // MARK: - Helpers

    private func createSUT(database: DatabaseProtocol,
                           person: PersonDTO? = nil,
                           userCollection: UserCollectionDTO? = nil,
                           type: AddCardType) -> AddCardViewController {
        let viewController = AddCardViewController(with: view)
        let router = AddCardNavigator(viewController)
        let interactor = AddCardInteractor(service: service)
        let viewModel = AddCardViewModel(person: person, userCollection: userCollection, type: type)
        let presenter = AddCardPresenter(view: viewController,
                                         interactor: interactor,
                                         database: database,
                                         navigator: router,
                                         viewModel: viewModel)
        viewController.presenter = presenter
        return viewController
    }
}
