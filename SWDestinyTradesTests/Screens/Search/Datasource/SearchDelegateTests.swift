//
//  SearchDelegateTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 08/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import SWDestinyTrades

final class SearchDelegateTests: XCTestCase {

    private var sut: Search!
    private var delegate: SearchDelegateSpy!
    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        delegate = SearchDelegateSpy()
        tableView = UITableView()
        sut = Search()
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
}
