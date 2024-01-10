//
//  AddToDeckHeaderViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 05/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddToDeckHeaderViewTests: XCTestCase {

    private var sut: AddToDeckHeaderView!

    override func setUp() {
        super.setUp()
        sut = AddToDeckHeaderView(reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_prepareForReuse() {
        sut.prepareForReuse()

        // XCTAssertEqual(sut.baseViewCell.subtitleLabel.text, nil)
        // XCTAssertNil(sut.baseViewCell.iconImageView.image)
    }

    func test_height() {
        let height = AddToDeckHeaderView.height()

        XCTAssertEqual(height, 45)
    }

    func test_configureHeader() {
        sut.configureHeader()

        // XCTAssertEqual(sut.baseViewCell.titleLabel.text, "Captain Phasma")
        // XCTAssertEqual(sut.baseViewCell.subtitleLabel.text, "Awakenings -- Legendary")
        // XCTAssertNotNil(sut.baseViewCell.iconImageView.image)
    }

    func test_valueChanged() {
        // sut.valueChanged()

        // XCTAssertEqual(sut.baseViewCell.titleLabel.text, "Captain Phasma")
        // XCTAssertEqual(sut.baseViewCell.subtitleLabel.text, "Awakenings -- Legendary")
        // XCTAssertNotNil(sut.baseViewCell.iconImageView.image)
    }
}
