//
//  HttpStatusCodeTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Testing

@testable import SWDestinyTrades

final class HttpStatusCodeTests {

    @Test
    func testInitFromStringValue_withValidString_shouldReturnCorrectStatusCode() {
        let statusCode = HttpStatusCode(fromStringValue: "200")
        #expect(statusCode == .ok)
    }

    @Test
    func testInitFromStringValue_withInvalidString_shouldReturnUnknownStatusCode() {
        let statusCode = HttpStatusCode(fromStringValue: "9999")
        #expect(statusCode == .unknown)
    }

    @Test
    func testInitFromStringValue_withNonNumericString_shouldReturnUnknownStatusCode() {
        let statusCode = HttpStatusCode(fromStringValue: "Invalid")
        #expect(statusCode == .unknown)
    }

    @Test
    func testInitFromRawValue_withValidInt_shouldReturnCorrectStatusCode() {
        let statusCode = HttpStatusCode(fromRawValue: 404)
        #expect(statusCode == .notFound)
    }

    @Test
    func testInitFromRawValue_withInvalidInt_shouldReturnUnknownStatusCode() {
        let statusCode = HttpStatusCode(fromRawValue: 9999)
        #expect(statusCode == .unknown)
    }

    @Test
    func testComparable_lessThan_shouldReturnTrue() {
        let statusCode1 = HttpStatusCode.ok
        let statusCode2 = HttpStatusCode.notFound
        #expect(statusCode1 < statusCode2)
    }

    @Test
    func testComparable_lessThan_shouldReturnFalse() {
        let statusCode1 = HttpStatusCode.ok
        let statusCode2 = HttpStatusCode.ok
        #expect((statusCode1 < statusCode2) == false)
    }

    @Test
    func testComparable_greaterThan_shouldReturnTrue() {
        let statusCode1 = HttpStatusCode.notFound
        let statusCode2 = HttpStatusCode.ok
        #expect(statusCode1 > statusCode2)
    }
}
