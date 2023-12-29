//
//  SetsListNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 30/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsListNavigatorTests: XCTestCase {

    private var sut: SetsListNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = SetsListNavigator(controller)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    func testNavigateToAboutViewController() {
        sut.navigate(to: .about)

        XCTAssertTrue(navigationController.currentPushedViewController is AboutViewController)
    }

    func testNavigateToCardListViewController() {
        sut.navigate(to: .cardList(database: nil, with: .stub()[0]))

        XCTAssertTrue(navigationController.currentPushedViewController is CardListViewController)
    }

    func testNavigateToSearchListViewController() {
        sut.navigate(to: .search(database: nil))

        XCTAssertTrue(navigationController.currentPushedViewController is SearchListViewController)
    }
}
