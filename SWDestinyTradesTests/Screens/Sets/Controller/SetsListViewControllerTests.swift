//
//  SetsListViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsListViewControllerTests: XCSnapshotableTestCase {

    private var sut: SetsListViewController!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var navigationController: UINavigationController!
    private var presenter: SetsPresenterSpy!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        sut = SetsListViewController()
        presenter = SetsPresenterSpy()
        sut.presenter = presenter
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        presenter = nil
        navigationController = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is SetsView)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallViewDidLoadCount, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        // XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_retrieveSets() {
        sut.retrieveSets()

        XCTAssertEqual(presenter.didCallRetrieveSetsCount, 1)
    }

    func test_aboutButtonTouched() {
        sut.aboutButtonTouched()
        
        XCTAssertEqual(presenter.didCallAboutButtonTouchedCount, 1)
    }

    func test_searchButtonTouched() {
        sut.searchButtonTouched()
        
        XCTAssertEqual(presenter.didCallSearchButtonTouchedCount, 1)
    }

    func test_startLoading() {
        sut.startLoading()

        // XCTAssertEqual(view.didCallStartLoadingCount, 1)
    }

    func test_stopLoading() {
        sut.stopLoading()

        // XCTAssertEqual(view.didCallStopLoadingCount, 1)
    }
    
    func test_endRefreshControl() {
        sut.endRefreshControl()

        // XCTAssertEqual(view.didCallStartLoadingCount, 1)
    }

    func test_updateSetList() {
        sut.updateSetList([.stub()])

        // XCTAssertEqual(view.didCallUpdateCardList.count, 1)
    }

    func test_setupNavigationItem() {}

    func test_showNetworkErrorMessage() {
        sut.showNetworkErrorMessage()

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }
}
