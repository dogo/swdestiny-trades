//
//  DeckListViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 23/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckListViewControllerTests: XCTestCase {

    private var sut: DeckListViewController!
    private var view: DeckListViewSpy!
    private var presenter: DeckListPresenterSpy!
    private var navigationController: UINavigationController!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = DeckListViewSpy()
        presenter = DeckListPresenterSpy()
        sut = DeckListViewController(with: view)
        sut.presenter = presenter
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        navigationController = nil
        view = nil
        presenter = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is DeckListViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
        XCTAssertEqual(presenter.didCallLoadDataFromRealmCount, 1)
    }

    func test_didSelectDeck() {
        sut.viewDidLoad()
        view.didSelectDeck?(.stub())

        XCTAssertEqual(presenter.didCallNavigateToDeckBuilder.count, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
        XCTAssertEqual(view.didCallRefreshDataCount, 1)
    }

    func test_updateCollecionViewData() {
        sut.updateTableViewData(deckList: [.stub()])

        XCTAssertEqual(view.didCallUpdateTableViewData.count, 1)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle(L10n.decks)

        XCTAssertEqual(sut.navigationItem.title, "Decks")
    }
}
