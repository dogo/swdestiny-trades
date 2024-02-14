//
//  AddCardViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 14/02/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades
@testable import SwiftMessages

final class AddCardViewControllerTests: XCTestCase {

    private var sut: AddCardViewController!
    private var view: AddCardViewSpy!
    private var presenter: AddCardPresenterSpy!
    private var keyWindow: UIWindow!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = AddCardViewSpy()
        sut = AddCardViewController(with: view)
        presenter = AddCardPresenterSpy()
        sut.presenter = presenter
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
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
        sut.viewDidLoad()
        view.didSelectCard?(.stub())

        XCTAssertEqual(presenter.didCallInsert.count, 1)
        XCTAssertEqual(presenter.didCallInsert[0].name, "Captain Phasma")
    }

    func test_didSelectAccessory() {
        sut.viewDidLoad()
        view.didSelectAccessory?(.stub())

        XCTAssertEqual(presenter.didCallDidCardDetailButtonTouched.count, 1)
        XCTAssertEqual(presenter.didCallDidCardDetailButtonTouched[0].name, "Captain Phasma")
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

        XCTAssertEqual(presenter.didCallDoingSearch.count, 1)
        XCTAssertEqual(presenter.didCallDoingSearch[0], "jabba")
    }

    func test_showSuccessMessage() {
        let HUDProvider = HUDProviderSpy()
        sut.showSuccessMessage(card: .stub(), headUpDisplay: HeadUpDisplay(provider: HUDProvider))

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .labeledSuccess(title: "Added", subtitle: "Captain Phasma"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.2)
    }

    func test_showErrorMessage() {
        sut.showErrorMessage()

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func test_showNetworkErrorMessage() {
        sut.showNetworkErrorMessage()

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }
}
