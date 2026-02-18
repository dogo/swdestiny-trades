//
//  HttpStatusCodeTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 27/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class HttpStatusCodeTests: XCTestCase {

    func testInitFromStringValue_withValidString_shouldReturnCorrectStatusCode() {
        let statusCode = HttpStatusCode(fromStringValue: "200")
        XCTAssertEqual(statusCode, .ok)
    }

    func testInitFromStringValue_withInvalidString_shouldReturnUnknownStatusCode() {
        let statusCode = HttpStatusCode(fromStringValue: "9999")
        XCTAssertEqual(statusCode, .unknown)
    }

    func testInitFromStringValue_withNonNumericString_shouldReturnUnknownStatusCode() {
        let statusCode = HttpStatusCode(fromStringValue: "Invalid")
        XCTAssertEqual(statusCode, .unknown)
    }

    func testInitFromRawValue_withValidInt_shouldReturnCorrectStatusCode() {
        let statusCode = HttpStatusCode(fromRawValue: 404)
        XCTAssertEqual(statusCode, .notFound)
    }

    func testInitFromRawValue_withInvalidInt_shouldReturnUnknownStatusCode() {
        let statusCode = HttpStatusCode(fromRawValue: 9999)
        XCTAssertEqual(statusCode, .unknown)
    }

    func testComparable_lessThan_shouldReturnTrue() {
        let statusCode1 = HttpStatusCode.ok
        let statusCode2 = HttpStatusCode.notFound
        XCTAssertTrue(statusCode1 < statusCode2)
    }

    func testComparable_lessThan_shouldReturnFalse() {
        let statusCode1 = HttpStatusCode.ok
        let statusCode2 = HttpStatusCode.ok
        XCTAssertFalse(statusCode1 < statusCode2)
    }

    func testComparable_greaterThan_shouldReturnTrue() {
        let statusCode1 = HttpStatusCode.notFound
        let statusCode2 = HttpStatusCode.ok
        XCTAssertTrue(statusCode1 > statusCode2)
    }
}
