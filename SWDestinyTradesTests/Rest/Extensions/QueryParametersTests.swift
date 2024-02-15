//
//  QueryParametersTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class QueryParametersTests: XCTestCase {

    func test_items_Empty_Parameters() {
        let queryParameters: QueryParameters = [:]

        let items = queryParameters.items

        XCTAssertTrue(items.isEmpty, "Items array should be empty for empty query parameters.")
    }

    func test_items_single_parameter() {
        let queryParameters: QueryParameters = ["key": "value"]

        let items = queryParameters.items

        XCTAssertEqual(items.count, 1, "Items array should contain one item for a single parameter")
        XCTAssertEqual(items.first?.name, "key", "Item name should be 'key'")
        XCTAssertEqual(items.first?.value, "value", "Item value should be 'value'")
    }

    func test_items_multiple_parameters() {
        let queryParameters: QueryParameters = [
            "key1": "value1",
            "key2": "value2",
            "key3": "value3"
        ]

        let items = queryParameters.items

        XCTAssertEqual(items.count, 3, "Items array should contain three items for multiple parameters")
        XCTAssertTrue(items.contains { $0.name == "key1" && $0.value == "value1" }, "Item for key1 should exist")
        XCTAssertTrue(items.contains { $0.name == "key2" && $0.value == "value2" }, "Item for key2 should exist")
        XCTAssertTrue(items.contains { $0.name == "key3" && $0.value == "value3" }, "Item for key3 should exist")
    }
}
