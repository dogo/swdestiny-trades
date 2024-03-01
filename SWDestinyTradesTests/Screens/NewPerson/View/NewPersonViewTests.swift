//
//  NewPersonViewTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class NewPersonViewTests: XCTestCase {

    private var sut: NewPersonView!

    override func setUp() {
        super.setUp()
        sut = NewPersonView(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_retriveUserInput() {
        sut.firstNameTextField.text = "Darth"
        sut.lastNameTextField.text = "Vader"

        let userInput = sut.retriveUserInput()

        XCTAssertEqual(userInput.name, "Darth")
        XCTAssertEqual(userInput.lastName, "Vader")
    }

    func test_textFieldShouldReturn() {
        // isFirstResponder needs a UIWindow to work properly
        let controller = UIViewController()
        let keyWindow = UIWindow(frame: .testDevice)
        controller.view = sut
        keyWindow.showTestWindow(controller: controller)

        XCTAssertFalse(sut.lastNameTextField.isFirstResponder)

        let result = sut.textFieldShouldReturn(sut.firstNameTextField)

        XCTAssertTrue(sut.lastNameTextField.isFirstResponder)
        XCTAssertTrue(result)
    }
}
