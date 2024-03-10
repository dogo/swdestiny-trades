//
//  CardSearchCellTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 10/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class CardSearchCellTests: XCTestCase {

    private var sut: CardSearchCell!

    override func setUp() {
        super.setUp()
        sut = CardSearchCell(style: .default, reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_configureViews() {
        XCTAssertEqual(sut.accessoryType, .disclosureIndicator)
    }

    func test_configureCell() {
        sut.configureCell(cardDTO: .stub())

        XCTAssertEqual(sut.baseViewCell.titleLabel.text, "Captain Phasma")
        XCTAssertEqual(sut.baseViewCell.subtitleLabel.text, "Awakenings -- Legendary")
        XCTAssertEqual(sut.baseViewCell.accessoryLabel.text, "")
        XCTAssertNotNil(sut.baseViewCell.iconImageView.image)
    }

    func test_prepareForReuse() {
        sut.prepareForReuse()

        XCTAssertNil(sut.baseViewCell.titleLabel.text)
        XCTAssertNil(sut.baseViewCell.subtitleLabel.text)
        XCTAssertNil(sut.baseViewCell.accessoryLabel.text)
        XCTAssertNil(sut.baseViewCell.iconImageView.image)
    }
}
