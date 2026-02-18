//
//  BodyParametersTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class BodyParametersTests: XCTestCase {

    func test_dataEncoded() {
        let bodyParameters: BodyParameters = [
            "key1": "value1",
            "key2": 42,
            "key3": ["nestedKey": "nestedValue"]
        ]

        let data = bodyParameters.dataEncoded

        XCTAssertNotNil(data, "Encoded data should not be nil")

        if let data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                XCTAssertTrue(jsonObject is [String: Any], "Encoded data should be a dictionary")
            } catch {
                XCTFail("Error decoding the encoded data: \(error)")
            }
        }
    }
}
