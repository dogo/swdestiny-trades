//
//  AddCardTableDelegateTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 01/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddCardTableDelegateTests: XCTestCase {

    private var sut: AddCardTableDelegate!
    private var delegate: SearchDelegateSpy!

    override func setUp() {
        super.setUp()
        delegate = SearchDelegateSpy()
        sut = AddCardTableDelegate()
        sut.delegate = delegate
    }

    override func tearDown() {
        delegate = nil
        sut = nil
        super.tearDown()
    }

    func test_heightForRowAt() {
        let height = sut.tableView(UITableView(), heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
    }

    func test_didSelectRowAt() {
        sut.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(delegate.didCallDidSelectRow.count, 1)
    }

    func test_accessoryButtonTappedForRowWith() {
        sut.tableView(UITableView(), accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 0))

        XCTAssertEqual(delegate.didCallDidSelectAccessory.count, 1)
    }
}
