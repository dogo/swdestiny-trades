//
//  DeckBuilderViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 12/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckBuilderViewControllerTests: XCTestCase {

    private var sut: DeckBuilderViewController!
    private var view: DeckBuilderViewSpy!
    private var service: SWDestinyService!
    private var client: HttpClientMock!
    private var navigationController: UINavigationController!
    private var presenter: DeckBuilderPresenterSpy!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = DeckBuilderViewSpy()
        sut = DeckBuilderViewController(with: view)
        presenter = DeckBuilderPresenterSpy()
        sut.presenter = presenter
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        view = nil
        presenter = nil
        navigationController = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is DeckBuilderViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
    }

    func test_viewWillAppear() {
        sut.viewDidLoad()
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
        XCTAssertEqual(presenter.didCallLoadData.count, 1)
        XCTAssertNil(presenter.didCallLoadData[0])
    }

    func test_didSelectCard() {
        sut.viewDidLoad()
        view.didSelectCard?([.stub()], .stub())

        XCTAssertEqual(presenter.didCallNavigateToCardDetailViewController.count, 1)
        XCTAssertEqual(presenter.didCallNavigateToCardDetailViewController[0].cardList.count, 1)
        XCTAssertNotNil(presenter.didCallNavigateToCardDetailViewController[0].card)
    }

    func test_updateTableViewData() {
        let deck = DeckDTO.stub()
        sut.updateTableViewData(deck: deck)

        XCTAssertEqual(view.didCallUpdateTableViewData.count, 1)
        XCTAssertEqual(view.didCallUpdateTableViewData[0], deck)
    }

    func test_getDeckList() {
        _ = sut.getDeckList()

        XCTAssertEqual(view.didCallGetDeckListCount, 1)
    }

    func test_presentViewController() {
        let controller = UIViewControllerMock()

        sut.presentViewController(controller, animated: false)

        XCTAssertTrue(controller.isBeingPresented)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle("Deck Title")

        XCTAssertEqual(sut.navigationItem.title, "Deck Title")
    }
}
