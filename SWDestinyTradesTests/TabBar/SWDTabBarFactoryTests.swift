//
//  SWDTabBarFactoryTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 06/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class SWDTabBarFactoryTests: XCTestCase {

    private var sut: SWDTabBarFactory!

    override func setUp() {
        super.setUp()
        sut = SWDTabBarFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_makeSetsList() {
        XCTAssertNotNil(sut.makeSetsList(with: nil))
    }

    func test_makeDeckList() {
        XCTAssertNotNil(sut.makeDeckList(with: nil))
    }

    func test_makePeopleList() {
        XCTAssertNotNil(sut.makePeopleList(with: nil))
    }

    func test_makeUserCollection() {
        XCTAssertNotNil(sut.makeUserCollection(with: nil))
    }
}
