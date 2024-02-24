//
//  LoanDetailCellTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class LoanDetailCellTests: XCTestCase {

    private var sut: LoanDetailCell!

    override func setUp() {
        super.setUp()
        sut = LoanDetailCell(style: .default, reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_configureCell() {
        sut.configureCell(cardDTO: .stub())

        XCTAssertEqual(sut.titleLabel.text, "Captain Phasma")
        XCTAssertNotNil(sut.iconImageView.image)
        XCTAssertEqual(sut.subtitleLabel.text, "Awakenings")
        XCTAssertEqual(sut.quantityLabel.text, "1")
        XCTAssertEqual(sut.quantityStepper.value, 1.0)
    }

    func test_prepareForReuse() {
        sut.prepareForReuse()

        XCTAssertNil(sut.titleLabel.text)
        XCTAssertNil(sut.iconImageView.image)
        XCTAssertNil(sut.subtitleLabel.text)
        XCTAssertNil(sut.quantityLabel.text)
        XCTAssertEqual(sut.quantityStepper.value, 1.0)
    }

    func test_setStepperVisibility_to_hidden() {
        sut.setStepperVisibility(true)

        XCTAssertTrue(sut.quantityStepper.isHidden)
    }

    func test_setStepperVisibility_to_visible() {
        sut.setStepperVisibility(false)

        XCTAssertFalse(sut.quantityStepper.isHidden)
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
}
