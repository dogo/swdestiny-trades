//
//  SearchListViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 19/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SearchListViewControllerTests: XCTestCase {

    private var sut: SearchListViewController!
    private var presenter: SearchLisPresenterSpy!
    private var view: SearchViewSpy!
    private var database: DatabaseProtocol!
    private var navigationController: UINavigationControllerMock!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = SearchViewSpy()
        presenter = SearchLisPresenterSpy()
        sut = SearchListViewController(with: view)
        sut.presenter = presenter
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        sut = nil
        database = nil
        view = nil
        navigationController = nil
        keyWindow = nil
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is SearchViewType)
    }

    func test_didSelectCard() {
        sut.viewDidLoad()
        view.didSelectCard?(.stub())

        XCTAssertEqual(presenter.didCallNavigateToCardDetailValues.count, 1)
        XCTAssertNotNil(presenter.didCallNavigateToCardDetailValues[0])
    }

    func test_doingSearch() {
        sut.viewDidLoad()
        view.doingSearch?("Panda")

        XCTAssertEqual(presenter.didCallSearchValues.count, 1)
        XCTAssertEqual(presenter.didCallSearchValues[0], "Panda")
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle("Darth Vader")

        XCTAssertEqual(sut.navigationItem.title, "Darth Vader")
    }

    func test_startLoading() {
        sut.startLoading()

        XCTAssertEqual(view.didCallStartLoadingCount, 1)
    }

    func test_stopLoading() {
        sut.stopLoading()

        XCTAssertEqual(view.didCallStopLoadingCount, 1)
    }

    func test_updateTableViewData() {
        sut.updateTableViewData([.stub()])

        XCTAssertEqual(view.didCallUpdateSearchListValues.count, 1)
        XCTAssertNotNil(view.didCallUpdateSearchListValues[0])
    }

    func test_showNetworkErrorMessage() {
        sut.showNetworkErrorMessage()

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }
}
