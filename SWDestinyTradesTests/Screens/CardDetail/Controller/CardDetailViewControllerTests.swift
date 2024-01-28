//
//  CardDetailViewControllerTests.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 25/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import PKHUD
@testable import SWDestinyTrades

final class CardDetailViewControllerTests: XCTestCase {

    private var sut: CardDetailViewController!
    private var view: CardViewSpy!
    private var presenter: CardDetailPresenterSpy!
    private var keyWindow: UIWindow!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        view = CardViewSpy()
        sut = CardDetailViewController(with: view)
        presenter = CardDetailPresenterSpy()
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

        XCTAssertTrue(sut.view is CardViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallViewDidLoadCount, 1)
        XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_currentPageChanged() {
        sut.viewDidLoad()
        view.currentPageChanged?(1)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_setSlideshowImageInputs() {
        sut.setSlideshowImageInputs([])

        XCTAssertEqual(view.didCallSetSlideshowImageInputs.count, 0)
    }

    func test_setCurrentPage() {
        sut.setCurrentPage(1, animated: false)

        XCTAssertEqual(view.didCallSetCurrentPage[0].page, 1)
        XCTAssertEqual(view.didCallSetCurrentPage[0].animated, false)
    }

    func test_getCurrentPage() {
        XCTAssertEqual(sut.getCurrentPage(), 0)
    }

    func test_getCurrentSlideshowItem() {
        XCTAssertNotNil(sut.getCurrentSlideshowItem())
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle("Card Title")

        XCTAssertEqual(sut.navigationItem.title, "Card Title")
    }

    func test_showSuccessMessage() {
        sut.showSuccessMessage(card: .stub())

        XCTAssertTrue(keyWindow.subviews.contains { $0 is ContainerView })
    }

    func test_presentViewController() {
        let controller = UIViewControllerMock()

        sut.presentViewController(controller, animated: false)

        XCTAssertTrue(controller.isBeingPresented)
    }
}
