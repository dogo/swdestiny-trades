//
//  SearchListViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 19/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class SearchListViewControllerFactoryTests: XCTestCase {

    private var sut: SearchListViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = SearchListViewControllerFactory(database: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_controller_creation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
