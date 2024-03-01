//
//  NewPersonViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class NewPersonViewControllerFactoryTests: XCTestCase {

    private var sut: NewPersonViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = NewPersonViewControllerFactory(delegate: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_controller_creation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
