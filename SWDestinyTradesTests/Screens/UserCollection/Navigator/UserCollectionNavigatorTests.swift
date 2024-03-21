//
//  UserCollectionNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 21/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class UserCollectionNavigatorTests: XCTestCase {

    private var sut: UserCollectionNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = UserCollectionNavigator(controller)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    func test_navigate_to_cardDetailViewController() {
        sut.navigate(to: .cardDetail(database: nil, with: [.stub()], card: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    func test_navigate_to_addCardViewController() {
        sut.navigate(to: .addCard(database: nil, with: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is AddCardViewController)
    }
}
