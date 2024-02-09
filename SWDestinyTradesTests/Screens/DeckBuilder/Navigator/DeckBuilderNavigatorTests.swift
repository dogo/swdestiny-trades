//
//  DeckBuilderNavigatorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 09/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckBuilderNavigatorTests: XCTestCase {

    private var sut: DeckBuilderNavigator!
    private var navigationController: UINavigationControllerMock!

    override func setUp() {
        super.setUp()
        let controller = UIViewController()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = DeckBuilderNavigator(controller)
    }

    override func tearDown() {
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    func test_navigate_to_addToDeckViewController() {
        sut.navigate(to: .addToDeck(database: nil, with: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is AddToDeckViewController)
    }

    func test_navigate_to_cardDetailViewController() {
        sut.navigate(to: .cardDetail(database: nil, with: [.stub()], card: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is CardDetailViewController)
    }

    func test_navigate_to_deckGraphViewController() {
        sut.navigate(to: .deckGraph(with: .stub()))

        XCTAssertTrue(navigationController.currentPushedViewController is DeckGraphViewController)
    }
}
