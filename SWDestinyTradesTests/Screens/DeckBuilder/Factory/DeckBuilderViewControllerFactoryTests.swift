//
//  DeckBuilderViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class DeckBuilderViewControllerFactoryTests: XCTestCase {

    private var sut: DeckBuilderViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = DeckBuilderViewControllerFactory(database: nil,
                                               deckDTO: .stub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testControllerCreation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
