//
//  LoansDetailViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class LoansDetailViewControllerFactoryTests: XCTestCase {

    private var sut: LoansDetailViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = LoansDetailViewControllerFactory(database: nil,
                                               person: .stub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_controller_creation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
