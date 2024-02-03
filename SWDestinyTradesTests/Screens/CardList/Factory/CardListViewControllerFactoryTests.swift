//
//  CardListViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class CardListViewControllerFactoryTests: XCTestCase {

    private var sut: CardListViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = CardListViewControllerFactory(database: nil,
                                            setDTO: .stub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testControllerCreation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
