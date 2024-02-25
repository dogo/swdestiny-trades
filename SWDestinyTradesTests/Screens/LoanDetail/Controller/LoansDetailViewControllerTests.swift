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
    private var navigationController: UINavigationController!
    private var keyWindow: UIWindow!
    private var database: RealmDatabase?

    override func setUp() {
        super.setUp()
        keyWindow = UIWindow(frame: .testDevice)
        database = RealmDatabaseHelper.createMemoryDatabase(identifier: #function)
        sut = LoansDetailViewController(database: database, person: .stub())
        navigationController = UINavigationControllerMock(rootViewController: sut)
        keyWindow.showTestWindow(controller: navigationController)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        keyWindow.cleanTestWindow()
        super.tearDown()
    }

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.view is LoanDetailViewType)
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()

        // XCTAssertEqual(presenter.didCallSetupNavigationItemsCount, 1)
        // XCTAssertEqual(presenter.didCallLoadDataFromRealmCount, 1)
    }

    func test_didSelectCard() {
        sut.viewDidLoad()
        // view.didSelectCard?(.stub())

        // XCTAssertEqual(presenter.didCallNavigateToDeckBuilder.count, 1)
    }

    func test_didSelectAddItem() {
        sut.viewDidLoad()
        // view.didSelectCard?(.stub())

        // XCTAssertEqual(presenter.didCallNavigateToDeckBuilder.count, 1)
    }

    func test_viewWillAppear() {
        sut.viewWillAppear(false)

        // XCTAssertEqual(presenter.didCallSetNavigationTitleCount, 1)
        // XCTAssertEqual(view.didCallReloadDataCount, 1)
    }
}
