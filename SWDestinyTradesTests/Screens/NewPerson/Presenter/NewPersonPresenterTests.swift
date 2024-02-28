//
//  NewPersonPresenterTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class NewPersonPresenterTests: XCTestCase {

    private var sut: NewPersonPresenter!
    private var navigationController: UINavigationControllerMock!
    private var controller: NewPersonViewControllerSpy!
    private var delegate: UpdateTableDataDelegateSpy!

    override func setUp() {
        super.setUp()
        controller = NewPersonViewControllerSpy()
        delegate = UpdateTableDataDelegateSpy()
        navigationController = UINavigationControllerMock(rootViewController: controller)
        sut = NewPersonPresenter(controller: controller,
                                 delegate: delegate)
    }

    override func tearDown() {
        controller = nil
        navigationController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Test setupNavigationItems

    func test_setupNavigationItems() {
        var expectedItem: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            expectedItem = items
        }

        XCTAssertEqual(expectedItem?.count, 1)
    }

    // MARK: - Test setNavigationTitle

    func test_setNavigationTitle() {
        sut.setNavigationTitle()

        XCTAssertEqual(controller.didCallSetNavigationTitle.count, 1)
        XCTAssertEqual(controller.didCallSetNavigationTitle[0], "New Person")
    }

    // MARK: - Test addButtonTouched

    func test_doneButtonTouched() {
        var barButtonItems: [UIBarButtonItem]? = []
        sut.setupNavigationItems { items in
            barButtonItems = items
        }
        let addButton = barButtonItems?[0]
        _ = addButton?.target?.perform(addButton!.action, with: nil)

        XCTAssertEqual(controller.didCallCloseViewControllerCount, 1)
        XCTAssertEqual(delegate.didCallInsertNew.count, 1)
        XCTAssertNotNil(delegate.didCallInsertNew[0])
    }
}
