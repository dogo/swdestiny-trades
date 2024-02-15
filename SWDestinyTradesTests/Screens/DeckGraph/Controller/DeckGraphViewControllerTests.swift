//
//  DeckGraphViewControllerTests.swift
//  SWDestiny-TradesTests
//
//  Created by diogo.autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckGraphViewControllerTests: XCTestCase {

    private var sut: DeckGraphViewController!
    private var view: DeckGraphViewSpy!
    private var presenter: DeckGraphPresenterSpy!
    private var navigationController: UINavigationController!
    private var keyWindow: UIWindow!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = DeckGraphViewSpy()
        presenter = DeckGraphPresenterSpy()
        sut = DeckGraphViewController(with: view)
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

        XCTAssertTrue(sut.view is DeckGraphViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallUpdateCollecionViewDataCount, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_updateCollecionViewData() {
        sut.updateCollecionViewData(deck: .stub())

        XCTAssertEqual(view.didCallUpdateCollecionViewData.count, 1)
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle(L10n.deckStatistics)

        XCTAssertEqual(sut.navigationItem.title, "Deck Statistics")
    }
}
