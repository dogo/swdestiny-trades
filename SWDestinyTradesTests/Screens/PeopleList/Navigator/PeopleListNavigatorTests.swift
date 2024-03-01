//
//  PeopleListNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class PeopleListNavigatorTests: XCTestCase {

    private var sut: PeopleListNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = PeopleListNavigator(controller)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    func test_navigate_to_loansDetailViewController() {
        sut.navigate(to: .loanDetail(database: nil, with: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is LoansDetailViewController)
    }

    func test_navigate_to_newPersonViewController() {
        sut.navigate(to: .newPerson(with: UpdateTableDataDelegateSpy()))

        XCTAssertTrue(navigationController.currentPushedViewController is NewPersonViewController)
    }
}
