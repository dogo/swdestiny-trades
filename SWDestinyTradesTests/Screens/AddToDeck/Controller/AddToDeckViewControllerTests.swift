//
//  AddToDeckViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class AddToDeckViewControllerTests: XCTestCase {

    private var window: UIWindow!
    private var sut: AddToDeckViewController!
    private var view: AddToDeckViewSpy!
    private var presenter: AddToDeckPresenterSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow(frame: .testDevice)
        view = AddToDeckViewSpy()
        presenter = AddToDeckPresenterSpy()
        sut = AddToDeckViewController(with: view)
        sut.presenter = presenter
        let navigationController = UINavigationController(rootViewController: sut)
        window.showTestWindow(controller: navigationController)
    }

    override func tearDownWithError() throws {
        window = nil
        sut = nil
        view = nil
        try super.tearDownWithError()
    }

    func test_navigationTitle() throws {
        sut.viewWillAppear(false)

        XCTAssertEqual(sut.navigationItem.title, L10n.addCard)
    }

    func testloadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is AddToDeckViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallRetrieveAllCards, 1)
    }

    func test_didSelectCard_closure() {
        sut.viewDidLoad()
        view.didSelectCard?(.stub())

        XCTAssertEqual(presenter.didCallInsertCard.count, 1)
        XCTAssertNotNil(presenter.didCallInsertCard[0])
    }

    func test_didSelectAccessory_closure() {
        sut.viewDidLoad()
        view.didSelectAccessory?(.stub())

        XCTAssertEqual(presenter.didCallNavigateToCardDetail.count, 1)
        XCTAssertNotNil(presenter.didCallNavigateToCardDetail[0])
    }

    func test_doingSearch_closure() {
        sut.viewDidLoad()
        view.doingSearch?("Text")

        XCTAssertEqual(presenter.didCallDoingSearch.count, 1)
        XCTAssertEqual(presenter.didCallDoingSearch[0], "Text")
    }

    func test_didSelectRemote_closure() {
        sut.viewDidLoad()
        view.didSelectRemote?()

        XCTAssertEqual(presenter.didCallRetrieveAllCards, 2)
    }

    func test_didSelectLocal_closure() {
        sut.viewDidLoad()
        view.didSelectLocal?()

        XCTAssertEqual(presenter.didCallLoadDataFromRealm, 1)
    }

    func test_startLoading() throws {
        sut.startLoading()

        XCTAssertEqual(view.didCallStartLoading, 1)
    }

    func test_stopLoading() throws {
        sut.stopLoading()

        XCTAssertEqual(view.didCallStopLoading, 1)
    }

    func test_updateSearchList() throws {
        sut.updateSearchList([.stub()])

        XCTAssertEqual(view.didCallUpdateSearchList.count, 1)
        XCTAssertNotNil(view.didCallUpdateSearchList[0])
    }

    func test_doingSearch() throws {
        sut.doingSearch("Text")

        XCTAssertEqual(view.didCallDoingSearch.count, 1)
        XCTAssertEqual(view.didCallDoingSearch[0], "Text")
    }

    func test_showSuccessMessage() throws {
        let HUDProvider = HUDProviderSpy()
        sut.showSuccessMessage(card: .stub(), headUpDisplay: HeadUpDisplay(provider: HUDProvider))

        XCTAssertEqual(HUDProvider.didCallShowHUD.count, 1)
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].contentType, .labeledSuccess(title: "Added", subtitle: "Captain Phasma"))
        XCTAssertEqual(HUDProvider.didCallShowHUD[0].delay, 0.2)
    }
}
