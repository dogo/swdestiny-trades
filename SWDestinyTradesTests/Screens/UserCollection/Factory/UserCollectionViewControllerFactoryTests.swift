//
//  UserCollectionViewControllerFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 22/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class UserCollectionViewControllerFactoryTests: BaseTestCase {

    private var sut: UserCollectionViewControllerFactory!

    override func setUp() {
        super.setUp()
        sut = UserCollectionViewControllerFactory(database: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_controller_creation() {
        XCTAssertNotNil(sut.createViewController())
    }
}
