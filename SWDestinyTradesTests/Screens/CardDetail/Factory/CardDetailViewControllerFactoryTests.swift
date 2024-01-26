//
//  CardDetailViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class CardDetailViewControllerFactoryTests: XCTestCase {

    private var sut: CardDetailViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = CardDetailViewControllerFactory(database: nil,
                                              cardList: [],
                                              card: .stub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testControllerCreation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
