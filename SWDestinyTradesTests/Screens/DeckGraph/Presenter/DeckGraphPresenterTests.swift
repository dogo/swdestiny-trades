//
//  DeckGraphPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 15/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckGraphPresenterTests: XCTestCase {

    private var sut: DeckGraphPresenter!
    private var controller: DeckGraphViewControllerSpy!

    override func setUp() {
        super.setUp()
        controller = DeckGraphViewControllerSpy()
        sut = DeckGraphPresenter(controller: controller, deckDTO: .stub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test updateCollecionViewData

    func test_updateCollecionViewData() {
        sut.updateCollecionViewData()

        XCTAssertEqual(controller.didCallUpdateCollecionViewData.count, 1)
        XCTAssertNotNil(controller.didCallUpdateCollecionViewData[0])
    }

    // MARK: - Test setNavigationTitle

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "Deck Statistics")
    }
}
