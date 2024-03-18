//
//  SearchListPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 18/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SearchListPresenterTests: XCTestCase {

    private var sut: SearchListPresenter!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var controller: SearchListViewControllerSpy!
    private var navigator: SearchNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        controller = SearchListViewControllerSpy()
        client = HttpClientMock()
        client.fileName = "card-list"
        service = SWDestinyService(client: client)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        navigator = SearchNavigator(controller)
        sut = SearchListPresenter(controller: controller,
                                  interactor: SearchListInteractor(service: service),
                                  database: nil,
                                  navigator: navigator)
    }

    override func tearDown() {
        client = nil
        service = nil
        navigationController = nil
        controller = nil
        navigator = nil
        sut = nil
        super.tearDown()
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "Search")
    }

    func test_search_card_with_success() async {
        client.fileName = "card-list"

        let expectation = XCTestExpectation(description: "Search cards expectation")

        Task {
            sut.search(query: "panda")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])

        await MainActor.run {
            XCTAssertEqual(controller.didCallUpdateTableViewData.count, 22)
            XCTAssertEqual(controller.didCallStopLoadingCount, 1)
        }
    }

    func test_search_card_with_failure() async {
        client.fileName = "card-list"
        client.error = true

        let expectation = XCTestExpectation(description: "Search cards expectation")

        Task {
            sut.search(query: "panda")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])

        await MainActor.run {
            XCTAssertEqual(controller.didCallShowNetworkErrorMessageCount, 1)
            XCTAssertEqual(controller.didCallStopLoadingCount, 1)
        }
    }

    func test_navigateToCardDetail() {
        sut.navigateToCardDetail(with: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }
}
