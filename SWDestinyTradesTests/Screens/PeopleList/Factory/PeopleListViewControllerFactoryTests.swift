//
//  PeopleListViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 06/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class PeopleListViewControllerFactoryTests: XCTestCase {

    private var sut: PeopleListViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = PeopleListViewControllerFactory(database: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_controller_creation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
