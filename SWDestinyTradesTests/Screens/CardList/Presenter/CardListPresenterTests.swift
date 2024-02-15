//
//  CardListPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardListPresenterTests: XCTestCase {

    private var sut: CardListPresenter!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var controller: CardListViewControllerSpy!
    private var navigator: CardListNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        controller = CardListViewControllerSpy()
        client = HttpClientMock()
        client.fileName = "card-list"
        service = SWDestinyService(client: client)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        navigator = CardListNavigator(controller)
        sut = CardListPresenter(controller: controller,
                                interactor: CardListInteractor(service: service),
                                database: nil,
                                navigator: navigator,
                                setDTO: .stub())
    }

    override func tearDown() {
        client = nil
        service = nil
        navigationController = nil
        navigator = nil
        sut = nil
        super.tearDown()
    }

    func test_retrieveCardsList_success() async {
        let expectation = XCTestExpectation(description: "Retrieve cards list expectation")

        Task {
            sut.retrieveCardsList()
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])

        await MainActor.run {
            XCTAssertEqual(controller.didCallStartLoadingCount, 1)
            // XCTAssertEqual(controller.didCallUpdateCardList.count, 22)
            // XCTAssertEqual(controller.didCallStopLoadingCount, 1)
        }
    }

    func test_retrieveSets_failure() async {
        client.error = true

        let expectation = XCTestExpectation(description: "Retrieve cards list expectation")

        Task {
            sut.retrieveCardsList()
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])

        await MainActor.run {
            XCTAssertEqual(controller.didCallShowNetworkErrorMessageCount, 1)
            XCTAssertEqual(controller.didCallStopLoadingCount, 1)
        }
    }

    func test_didSelectCard() {
        sut.didSelectCard(cardList: [], card: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "Awakenings")
    }
}
