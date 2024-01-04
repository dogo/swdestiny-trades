//
//  AddToDeckCardDelegateTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 04/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddToDeckCardDelegateTests: XCTestCase {

    private var sut: AddToDeckCardDelegate!
    private var delegate: SearchDelegateSpy!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        delegate = SearchDelegateSpy()
        tableView = UITableView()
        sut = AddToDeckCardDelegate()
        sut.delegate = delegate
    }

    override func tearDown() {
        delegate = nil
        tableView = nil
        sut = nil
        super.tearDown()
    }

    func test_heightForRowAt() {
        let height = sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(height, 53)
    }

    func test_didSelectRowAt() {
        sut.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(delegate.didCallDidSelectRow.count, 1)
    }

    func test_accessoryButtonTappedForRowWith() {
        sut.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 0))

        XCTAssertEqual(delegate.didCallDidSelectAccessory.count, 1)
    }

    func test_viewForHeaderInSection_zero_is_not_nil() {
        tableView.register(headerFooterViewType: AddToDeckHeaderView.self)

        let header = sut.tableView(tableView, viewForHeaderInSection: 0)

        XCTAssertNotNil(header)
    }

    func test_viewForHeaderInSection_non_zero_is_nil() {
        tableView.register(headerFooterViewType: AddToDeckHeaderView.self)

        let header = sut.tableView(tableView, viewForHeaderInSection: 1)

        XCTAssertNil(header)
    }

    func test_heightForHeaderInSection() {
        let height = sut.tableView(tableView, heightForHeaderInSection: 0)

        XCTAssertEqual(height, 45)
    }
}
