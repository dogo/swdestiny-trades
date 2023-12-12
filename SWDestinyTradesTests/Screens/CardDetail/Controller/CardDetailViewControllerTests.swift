//
//  CardDetailViewControllerTests.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 25/03/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardDetailViewControllerTests: XCTestCase {

    private var controller: CardDetailViewController!
    private let cardList = [CardDTO()]

    override func setUp() {
        super.setUp()
        controller = CardDetailViewController(database: nil, cardList: cardList, selected: CardDTO())
    }

    func testCreateController() {
        XCTAssertNotNil(controller)
    }

    func testViewIsKindOfCardView() {
        XCTAssertTrue(controller.view is CardView)
    }

    func testNavigationTitle() {
        _ = UINavigationController(rootViewController: controller)
        controller.viewWillAppear(false)

        XCTAssertEqual(controller.navigationItem.title, "")
    }
}
