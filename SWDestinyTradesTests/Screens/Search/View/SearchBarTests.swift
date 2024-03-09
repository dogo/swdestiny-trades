//
//  SearchBarTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 09/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class SearchBarTests: XCTestCase {

    private var sut: SearchBar!
    private var delegate: PeopleListPresenterSpy!

    override func setUp() {
        super.setUp()
        delegate = PeopleListPresenterSpy()
        sut = SearchBar(frame: .testDevice)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_doingSearch() {
        var didCallDoingSearch = 0
        var didCallDoingSearchValues: [String] = []
        sut.doingSearch = { text in
            didCallDoingSearch += 1
            didCallDoingSearchValues.append(text)
        }

        sut.text = "Jabba"
        sut.searchBarSearchButtonClicked(sut)

        XCTAssertEqual(didCallDoingSearch, 1)
        XCTAssertEqual(didCallDoingSearchValues[0], "Jabba")
        XCTAssertFalse(sut.isFirstResponder)
    }
}
