//
//  DeckListViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 21/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class DeckListViewControllerFactoryTests: XCTestCase {

    private var sut: DeckListViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = DeckListViewControllerFactory(database: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_controller_creation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
