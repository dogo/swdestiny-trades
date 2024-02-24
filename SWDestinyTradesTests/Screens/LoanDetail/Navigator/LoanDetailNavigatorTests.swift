//
//  LoanDetailNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/11/22.
//  Copyright © 2022 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class LoanDetailNavigatorTests: XCTestCase {

    private var sut: LoanDetailNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = LoanDetailNavigator(controller)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    func testNavigateToCardDetailViewController() {
        sut.navigate(to: .cardDetail(database: nil, with: [.stub()], card: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    func testNavigateToAddCardViewController() {
        sut.navigate(to: .addCard(database: nil, with: .stub(), type: .borrow))

        XCTAssertTrue(navigationController.currentPushedViewController is AddCardViewController)
    }
}
