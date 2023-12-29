//
//  AboutViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class AboutViewControllerFactoryTests: XCTestCase {

    private var sut: AboutViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = AboutViewControllerFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testControllerCreation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
