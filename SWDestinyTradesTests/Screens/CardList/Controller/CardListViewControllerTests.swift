//
//  CardListViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardListViewControllerTests: XCTestCase {

    private var sut: CardListViewController!
    private var view: CardListViewSpy!
    private var presenter: CardListPresenterSpy!
    private var keyWindow: UIWindow!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = CardListViewSpy()
        sut = CardListViewController(with: view)
        presenter = CardListPresenterSpy()
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

        XCTAssertTrue(sut.view is CardListViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallRetrieveCardsListeCount, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_didSelectCard() {
        sut.viewDidLoad()
        view.didSelectCard?([.stub()], .stub())

        XCTAssertEqual(presenter.didCallDidSelectCard.count, 1)
        XCTAssertEqual(presenter.didCallDidSelectCard[0].cardList[0].name, "Captain Phasma")
        XCTAssertEqual(presenter.didCallDidSelectCard[0].card.name, "Captain Phasma")
    }

    func test_startLoading() {
        sut.startLoading()

        XCTAssertEqual(view.didCallStartLoadingCount, 1)
    }

    func test_stopLoading() {
        sut.stopLoading()

        XCTAssertEqual(view.didCallStopLoadingCount, 1)
    }

    func test_updateCardList() {
        sut.updateCardList([.stub()])

        XCTAssertEqual(view.didCallUpdateCardList.count, 1)
    }

    func test_showNetworkErrorMessage() {
        sut.showNetworkErrorMessage()

        // XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle("Card Title")

        XCTAssertEqual(sut.navigationItem.title, "Card Title")
    }
}
