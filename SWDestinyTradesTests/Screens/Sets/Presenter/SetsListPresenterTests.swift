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

    func testViewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(view.didCallStartAnimating, 1)
        XCTAssertEqual(view.didCallSetupNavigationItem, 1)
    }

    func testDidSelectSet() {
        sut.didSelectSet(.stub()[0])

        XCTAssertTrue(navigationController.currentPushedViewController is CardListViewController)
    }

    func testAboutButtonTouched() {
        sut.aboutButtonTouched()

        XCTAssertTrue(navigationController.currentPushedViewController is AboutViewController)
    }

    func testSearchButtonTouched() {
        sut.searchButtonTouched()

        XCTAssertTrue(navigationController.currentPushedViewController is SearchListViewController)
    }
}
