//
//  AddToDeckViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class AddToDeckViewControllerFactoryTests: XCTestCase {

    private var sut: AddToDeckViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = AddToDeckViewControllerFactory(database: nil, deck: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testControllerCreation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
