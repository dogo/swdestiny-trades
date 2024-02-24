//
//  DeckListCellTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class DeckListCellTests: XCTestCase {

    private var sut: DeckListCell!

    override func setUp() {
        super.setUp()
        sut = DeckListCell(style: .default, reuseIdentifier: #function)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_configureCell() {
        sut.configureCell(deck: .stub())

        XCTAssertEqual(sut.titleEditText.text, "Mock Deck")
        XCTAssertEqual(sut.subTitle.text, "22 cards")
    }

    func test_prepareForReuse() {
        sut.prepareForReuse()

        XCTAssertEqual(sut.titleEditText.text, "")
        XCTAssertFalse(sut.titleEditText.isUserInteractionEnabled)
    }

    func test_accessoryButtonTouched_with_userInteractionEnabled() {
        // isFirstResponder needs a UIWindow to work properly
        let controller = UIViewController()
        let keyWindow = UIWindow(frame: .testDevice)
        controller.view = sut
        keyWindow.showTestWindow(controller: controller)

        XCTAssertFalse(sut.titleEditText.isFirstResponder)

        sut.accessoryButton.sendActions(for: .touchUpInside)

        XCTAssertTrue(sut.titleEditText.isFirstResponder)
    }

    func test_accessoryButtonTouched_with_userInteraction_disaabled() {
        var didCallAccessoryButtonTouchedCount = 0
        var didCallAccessoryButtonTouchedValue: (String, DeckDTO)?
        sut.editButtonTouched = { name, deck in
            didCallAccessoryButtonTouchedCount += 1
            didCallAccessoryButtonTouchedValue = (name, deck)
        }

        sut.configureCell(deck: .stub())
        sut.titleEditText.isUserInteractionEnabled = true
        sut.accessoryButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(didCallAccessoryButtonTouchedCount, 1)
        XCTAssertEqual(didCallAccessoryButtonTouchedValue?.0, "Mock Deck")
        XCTAssertNotNil(didCallAccessoryButtonTouchedValue?.1)
    }

    func test_textFieldShouldReturn() {
        sut.configureCell(deck: .stub())
        sut.titleEditText.isUserInteractionEnabled = true

        var didCallAccessoryButtonTouchedCount = 0
        var didCallAccessoryButtonTouchedValue: (String, DeckDTO)?
        sut.editButtonTouched = { name, deck in
            didCallAccessoryButtonTouchedCount += 1
            didCallAccessoryButtonTouchedValue = (name, deck)
        }

        _ = sut.textFieldShouldReturn(sut.titleEditText)

        XCTAssertEqual(didCallAccessoryButtonTouchedCount, 1)
        XCTAssertEqual(didCallAccessoryButtonTouchedValue?.0, "Mock Deck")
        XCTAssertNotNil(didCallAccessoryButtonTouchedValue?.1)
    }
}
