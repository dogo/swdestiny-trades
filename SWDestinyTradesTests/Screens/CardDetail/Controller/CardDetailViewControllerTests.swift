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

    private var sut: CardDetailViewController!

    override func setUp() {
        super.setUp()
        sut = CardDetailViewController()
    }

    func testCreateController() {
        XCTAssertNotNil(sut)
    }

    func testViewIsKindOfCardView() {
        XCTAssertTrue(sut.view is CardView)
    }

    func testNavigationTitle() {
        _ = UINavigationController(rootViewController: sut)
        sut.viewWillAppear(false)

        XCTAssertEqual(sut.navigationItem.title, "")
    }
}
