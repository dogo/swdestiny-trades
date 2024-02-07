//
//  SetsListPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsListPresenterTests: XCTestCase {

    private var sut: SetsListPresenter!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var view: SetsListViewSpy!
    private var navigator: SetsListNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        client = HttpClientMock()
        client.fileName = "sets"
        service = SWDestinyService(client: client)
        navigationController = UINavigationControllerMock(rootViewController: controller)
        view = SetsListViewSpy()
        navigator = SetsListNavigator(controller)
        sut = SetsListPresenter(view: view,
                                interactor: SetsListInteractor(service: service),
                                database: nil,
                                navigator: navigator)
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

    func test_ViewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(view.didCallStartAnimatingCount, 1)
        XCTAssertEqual(view.didCallSetupNavigationItemCount, 1)
    }

    func test_retrieveSets_success() async {
        client.fileName = "sets"

        let expectation = XCTestExpectation(description: "Retrieve sets expectation")

        Task {
            sut.retrieveSets()
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])

        await MainActor.run {
            XCTAssertEqual(view.didCallUpdateSetList.count, 12)
            XCTAssertEqual(view.didCallStopAnimatingCount, 1)
            XCTAssertEqual(view.didCallEndRefreshControlCount, 1)
        }
    }

    func test_retrieveSets_failure() async {
        client.fileName = "sets"
        client.error = true

        let expectation = XCTestExpectation(description: "Retrieve sets expectation")

        Task {
            sut.retrieveSets()
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])

        await MainActor.run {
            XCTAssertEqual(view.didCallShowNetworkErrorMessageCount, 1)
            XCTAssertEqual(view.didCallStopAnimatingCount, 1)
            XCTAssertEqual(view.didCallEndRefreshControlCount, 1)
        }
    }

    func test_didSelectSet() {
        sut.didSelectSet(.stub())

        XCTAssertTrue(navigationController.currentPushedViewController is CardListViewController)
    }

    func test_aboutButtonTouched() {
        sut.aboutButtonTouched()

        XCTAssertTrue(navigationController.currentPushedViewController is AboutViewController)
    }

    func test_searchButtonTouched() {
        sut.searchButtonTouched()

        XCTAssertTrue(navigationController.currentPushedViewController is SearchListViewController)
    }
}
