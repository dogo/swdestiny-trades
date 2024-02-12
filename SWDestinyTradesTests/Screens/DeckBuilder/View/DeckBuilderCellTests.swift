//
//  DeckBuilderCellTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 12/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckBuilderCellTests: XCTestCase {

    private var sut: DeckBuilderCell!

    override func setUp() {
        super.setUp()
        sut = DeckBuilderCell(style: .default, reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_configureCell() {
        sut.configureCell(card: .stub())

        XCTAssertNotNil(sut.iconImageView.image)
        XCTAssertEqual(sut.titleLabel.text, "Captain Phasma")
        XCTAssertEqual(sut.subtitleLabel.text, "Elite Trooper")
        XCTAssertEqual(sut.quantityLabel.text, "1")
    }

    func test_prepareForReuse() {
        sut.prepareForReuse()

        XCTAssertNil(sut.iconImageView.image)
        XCTAssertNil(sut.titleLabel.text)
        XCTAssertNil(sut.subtitleLabel.text)
        XCTAssertNil(sut.quantityLabel.text)
    }

    func test_stepperValueChanged() {
        var didCallStepperValueChangedCount = 0
        var didCallStepperValueChangedValue: Int?
        sut.stepperValueChanged = { value in
            didCallStepperValueChangedCount += 1
            didCallStepperValueChangedValue = value
        }

        sut.quantityStepper.value = 4.0
        sut.quantityStepper.sendActions(for: .valueChanged)

        XCTAssertEqual(didCallStepperValueChangedCount, 1)
        XCTAssertEqual(didCallStepperValueChangedValue, 4)
    }

    func test_eliteButtonTouched() {
        var didCallEliteButtonTouchedCount = 0
        var didCallEliteButtonTouchedValue: Bool = false
        sut.eliteButtonTouched = { value in
            didCallEliteButtonTouchedCount += 1
            didCallEliteButtonTouchedValue = value
        }

        sut.eliteButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(didCallEliteButtonTouchedCount, 1)
        XCTAssertTrue(didCallEliteButtonTouchedValue)
    }
}
