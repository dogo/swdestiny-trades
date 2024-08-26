//
//  FloatingTextfieldTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 25/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class FloatingTextfieldTests: XCTestCase {

    private var sut: FloatingTextfield!
    private var notificationCenter: NotificationCenterMock!

    override func setUp() {
        super.setUp()
        notificationCenter = NotificationCenterMock()
        sut = FloatingTextfield(frame: CGRect(x: 0, y: 0, width: 200, height: 50),
                                notificationCenter: notificationCenter)
        sut.animationDuration = 0.0
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInitialState() {
        sut.draw(sut.frame)
        sut.drawPlaceholder(in: sut.frame)

        XCTAssertEqual(sut.isLifted, false)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaBefore)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaBefore)
    }

    func testDrawUnderline() {
        sut.draw(CGRect(x: 0, y: 0, width: 200, height: 50))

        XCTAssertEqual(sut.underlineView.frame.size.height, sut.underlineWidth)
        XCTAssertEqual(sut.underlineView.frame.size.width, sut.frame.size.width)
        XCTAssertEqual(sut.underlineView.backgroundColor, sut.underlineColor)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaBefore)
    }

    func testDrawTextInRectWhenTextExists() {
        sut.placeholder = "Test Placeholder"
        sut.text = "Test Text"

        sut.drawText(in: CGRect(x: 0, y: 0, width: 100, height: 50))

        XCTAssertEqual(sut.placeholderLabel.text, "Test Placeholder")
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaAfter, accuracy: 0.0001)
        XCTAssertTrue(sut.isLifted)
    }

    func testDrawTextInRectWhenTextIsEmpty() {
        sut.placeholder = "Test Placeholder"
        sut.text = ""

        sut.drawPlaceholder(in: CGRect(x: 0, y: 0, width: 100, height: 50))
        sut.drawText(in: CGRect(x: 0, y: 0, width: 100, height: 50))

        XCTAssertEqual(sut.placeholderLabel.text, "Test Placeholder")
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaBefore)
        XCTAssertFalse(sut.isLifted)
    }

    func testTextRectCalculation() {
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 50)

        let textRect = sut.textRect(forBounds: bounds)

        let expectedRect = bounds.insetBy(dx: sut.textInsetX, dy: sut.underlineWidth + 2.0)
        XCTAssertEqual(textRect, expectedRect)
    }

    func testEditingRectCalculation() {
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 50)

        let editingRect = sut.editingRect(forBounds: bounds)

        let expectedRect = bounds.insetBy(dx: sut.textInsetX, dy: sut.underlineWidth + 2.0)
        XCTAssertEqual(editingRect, expectedRect)
    }

    func testPlaceholderLabelSetup() {
        let placeholderText = "Test Placeholder"
        sut.placeholder = placeholderText
        sut.drawPlaceholder(in: sut.bounds)

        XCTAssertEqual(sut.placeholderLabel.text, placeholderText)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaBefore)
        XCTAssertEqual(sut.placeholderLabel.textColor, sut.placeholderTextColor)
    }

    func testLiftUpPlaceholder() {
        sut.didBeginChangeText()

        XCTAssertEqual(sut.isLifted, true)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaAfter, accuracy: 0.0001)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaAfter)
    }

    func testDidBeginChangeTextWhenLifted() {
        sut.isLifted = true
        sut.didBeginChangeText()

        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaAfter)
    }

    func testLiftDownPlaceholderIfTextIsEmpty() {
        sut.text = ""
        sut.didEndChangingText()

        XCTAssertEqual(sut.isLifted, false)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaBefore)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaBefore)
    }

    func testLiftDownPlaceholderIfTextIsNotEmpty() {
        sut.text = "Some text"
        sut.didBeginChangeText()
        sut.didEndChangingText()

        XCTAssertEqual(sut.isLifted, true)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaAfter, accuracy: 0.0001)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaAfter)
    }

    func testDidChangeText() {
        sut.text = "Some text"
        sut.didChangeText()

        XCTAssertEqual(sut.isLifted, true)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaAfter, accuracy: 0.0001)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaAfter)
    }

    func testPlaceholderTextChangesOnTextChange() {
        sut.text = ""
        sut.didChangeText()

        XCTAssertEqual(sut.isLifted, false)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaBefore)
    }

    func testPlaceholderTextChangesWhenLiftedAndTextIsEmpty() {
        sut.isLifted = true
        sut.text = ""
        sut.didChangeText()

        XCTAssertEqual(sut.isLifted, false)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaBefore)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaBefore)
    }

    func testPlaceholderLiftWhenEditingBegins() {
        sut.text = ""
        sut.didBeginChangeText()

        XCTAssertEqual(sut.isLifted, true)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaAfter, accuracy: 0.0001)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaAfter)
    }

    func testPlaceholderFallsWhenEditingEndsAndTextIsEmpty() {
        sut.text = ""
        sut.didEndChangingText()

        XCTAssertEqual(sut.isLifted, false)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaBefore)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaBefore)
    }

    func testPlaceholderRemainsLiftedWhenTextIsNotEmptyAfterEditing() {
        sut.text = "Some text"
        sut.didBeginChangeText()
        sut.didEndChangingText()

        XCTAssertEqual(sut.isLifted, true)
        XCTAssertEqual(sut.placeholderLabel.alpha, sut.placeholderAlphaAfter, accuracy: 0.0001)
        XCTAssertEqual(sut.underlineView.alpha, sut.underlineAlphaAfter)
    }

    func testNotificationObservers() {
        let textDidBeginEditingNotification = notificationCenter.notificationNames.contains(UITextField.textDidBeginEditingNotification)
        let textDidChangeNotification = notificationCenter.notificationNames.contains(UITextField.textDidChangeNotification)
        let textDidEndEditingNotification = notificationCenter.notificationNames.contains(UITextField.textDidEndEditingNotification)

        XCTAssertTrue(textDidBeginEditingNotification)
        XCTAssertTrue(textDidChangeNotification)
        XCTAssertTrue(textDidEndEditingNotification)
    }

    func testDeinit() {
        sut = nil
        XCTAssertEqual(notificationCenter.didCallRemoveObserverCount, 1)
    }
}
