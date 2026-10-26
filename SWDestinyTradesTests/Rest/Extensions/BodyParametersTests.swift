//
//  BodyParametersTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class BodyParametersTests {

    @Test
    func test_dataEncoded() {
        let bodyParameters: BodyParameters = [
            "key1": "value1",
            "key2": 42,
            "key3": ["nestedKey": "nestedValue"]
        ]

        let data = bodyParameters.dataEncoded

        #expect(data != nil, "Encoded data should not be nil")

        if let data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                #expect(jsonObject is [String: Any], "Encoded data should be a dictionary")
            } catch {
                Issue.record("Error decoding the encoded data: \(error)")
            }
        }
    }

    @Test
    func test_formEncoded_sortsKeysAndEscapesReservedCharacters() throws {
        let bodyParameters: BodyParameters = [
            "redirect_uri": "app://callback",
            "code": "a+b=c&d",
            "expires": 42
        ]

        let body = String(decoding: try #require(bodyParameters.formEncoded), as: UTF8.self)

        #expect(body == "code=a%2Bb%3Dc%26d&expires=42&redirect_uri=app://callback")
    }
}
