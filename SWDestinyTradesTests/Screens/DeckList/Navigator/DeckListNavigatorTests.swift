//
//  DeckListNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/11/22.
//  Copyright © 2022 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckListNavigatorTests: XCTestCase {

    private var sut: DeckListNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = DeckListNavigator(controller)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    func test_navigate_to_deckBuilderViewController() {
        sut.navigate(to: .deckBuilder(database: nil, with: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is DeckBuilderViewController)
    }
}
