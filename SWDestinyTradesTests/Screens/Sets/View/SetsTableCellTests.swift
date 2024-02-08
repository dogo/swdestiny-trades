//
//  SetsTableCellTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SetsTableCellTests: XCTestCase {

    private var sut: SetsTableCell!

    override func setUp() {
        super.setUp()
        sut = SetsTableCell(style: .default, reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_configureCell() {
        sut.configureCell(setDTO: .stub())

        XCTAssertEqual(sut.titleLabel?.text, "Awakenings")
        XCTAssertNotNil(sut.expansionImageView?.image)
    }

    func test_prepareForReuse() {
        sut.prepareForReuse()

        XCTAssertNil(sut.titleLabel?.text)
        XCTAssertNil(sut.expansionImageView?.image)
    }
}
