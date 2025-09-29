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

final class SearchListPresenterTests: BaseTestCase {

    private var sut: SearchListPresenter!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var controller: SearchListViewControllerSpy!
    private var navigator: SearchNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        controller = SearchListViewControllerSpy()
        client = DependencyManager.shared.resolve(type: HttpClientProtocol.self, mode: .shared) as? HttpClientMock
        client.fileName = "card-list"
        service = SWDestinyService()
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

        let stopExp = expectation(description: "stopLoading fulfilled")
        await MainActor.run {
            controller.stopLoadingExpectation = stopExp
        }

        sut.search(query: "panda")

        await fulfillment(of: [stopExp], timeout: 3.0)

        let updateCount = await MainActor.run { controller.didCallUpdateTableViewData.count }
        let stopCount = await MainActor.run { controller.didCallStopLoadingCount }

        XCTAssertEqual(updateCount, 22)
        XCTAssertEqual(stopCount, 1)
    }

    func test_search_card_with_failure() async {
        client.fileName = "card-list"
        client.error = true

        let errorExp = expectation(description: "error message shown")
        let stopExp = expectation(description: "stopLoading fulfilled")
        await MainActor.run {
            controller.errorExpectation = errorExp
            controller.stopLoadingExpectation = stopExp
        }

        sut.search(query: "panda")

        await fulfillment(of: [errorExp, stopExp], timeout: 3.0)

        let errorCount = await MainActor.run { controller.didCallShowNetworkErrorMessageCount }
        let stopCount = await MainActor.run { controller.didCallStopLoadingCount }

        XCTAssertEqual(errorCount, 1)
        XCTAssertEqual(stopCount, 1)
    }

    func test_navigateToCardDetail() {
        sut.navigateToCardDetail(with: .stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }
}
