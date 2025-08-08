//
//  DeckGraphViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 15/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class DeckGraphViewControllerFactoryTests: BaseTestCase {

    private var sut: DeckGraphViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = DeckGraphViewControllerFactory(deck: .stub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_controller_creation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
