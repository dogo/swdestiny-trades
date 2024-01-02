//
//  AddCardCellTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 02/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardCellTests: XCTestCase {

    private var sut: AddCardCell!

    override func setUp() {
        super.setUp()
        sut = AddCardCell(style: .default, reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testConfigureCell() {
        sut.configureCell(cardDTO: .stub())

        XCTAssertEqual(sut.baseViewCell.titleLabel.text, "Captain Phasma")
        XCTAssertEqual(sut.baseViewCell.subtitleLabel.text, "Awakenings -- Legendary")
        XCTAssertNotNil(sut.baseViewCell.iconImageView.image)
    }

    func testPrepareForReuse() {
        sut.prepareForReuse()

        XCTAssertEqual(sut.baseViewCell.titleLabel.text, nil)
        XCTAssertEqual(sut.baseViewCell.subtitleLabel.text, nil)
        XCTAssertNil(sut.baseViewCell.iconImageView.image)
    }
}
