//
//  LoansDetailViewControllerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class LoansDetailViewControllerTests: XCTestCase {

    private var sut: LoansDetailViewController!
    private var view: LoanDetailViewSpy!
    private var presenter: LoansDetailsPresenterSpy!
    private var navigationController: UINavigationController!
    private var keyWindow: UIWindow!
    private var database: RealmDatabase?

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        view = LoanDetailViewSpy()
        presenter = LoansDetailsPresenterSpy()
        sut = LoansDetailViewController(with: view)
        sut.presenter = presenter
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        view = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is LoanDetailViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        XCTAssertEqual(presenter.didCallLoadDataFromRealmCount, 1)
    }

    func test_didSelectCard() {
        sut.viewDidLoad()
        view.didSelectCard?(.stub(), .borrow)

        XCTAssertEqual(presenter.didCallNavigateToCardDetailValues.count, 1)
        XCTAssertNotNil(presenter.didCallNavigateToCardDetailValues[0].card)
        XCTAssertEqual(presenter.didCallNavigateToCardDetailValues[0].destination, .borrow)
    }

    func test_didSelectAddItem() {
        sut.viewDidLoad()
        view.didSelectAddItem?(.borrow)

        XCTAssertEqual(presenter.didCallNavigateToAddCardValues.count, 1)
        XCTAssertEqual(presenter.didCallNavigateToAddCardValues[0], .borrow)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
    }

    func test_updateTableViewData() {
        sut.updateTableViewData(person: .stub())

        XCTAssertEqual(view.didCallUpdateTableViewData.count, 1)
        XCTAssertNotNil(view.didCallUpdateTableViewData[0])
    }

    func test_setNavigationTitle() {
        sut.setNavigationTitle("Darth Vader")

        XCTAssertEqual(sut.navigationItem.title, "Darth Vader")
    }
}
