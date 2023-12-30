//
//  AddCardNavigatorTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 16/10/21.
//  Copyright © 2021 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardNavigatorTests: XCTestCase {

    private var sut: AddCardNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = AddCardNavigator(controller)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    func testNavigateToCardDetailPushesToCardDetailViewController() {
        sut.navigate(to: .cardDetail(database: nil,
                                     with: [],
                                     card: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }
}
