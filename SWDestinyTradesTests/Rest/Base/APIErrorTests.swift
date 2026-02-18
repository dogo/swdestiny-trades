//
//  APIErrorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 04/09/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class APIErrorTests: XCTestCase {

    func test_invalid_data_error_description() {
        let error = APIError.invalidData
        XCTAssertEqual(error.localizedDescription, "Invalid Data")
    }

    func test_response_unsuccessful_error_description() {
        let error = APIError.responseUnsuccessful
        XCTAssertEqual(error.localizedDescription, "Response Unsuccessful")
    }

    func test_request_cancelled_error_description() {
        let error = APIError.requestCancelled
        XCTAssertEqual(error.localizedDescription, "Request Cancelled")
    }

    func test_key_not_found_error_description() {
        let key = TestCodingKey(stringValue: "testKey")
        let error = APIError.keyNotFound(key: key, context: "missing key")
        XCTAssertEqual(error.localizedDescription, "Could not find key testKey in JSON: missing key")
    }

    func test_value_not_found_error_description() {
        let error = APIError.valueNotFound(type: Int.self, context: "missing value")
        XCTAssertEqual(error.localizedDescription, "Could not find type Int in JSON: missing value")
    }

    func test_type_mismatch_error_description() {
        let error = APIError.typeMismatch(type: String.self, context: "type mismatch")
        XCTAssertEqual(error.localizedDescription, "Type mismatch for type String in JSON: type mismatch")
    }

    func test_data_corrupted_error_description() {
        let error = APIError.dataCorrupted(context: "data corrupted")
        XCTAssertEqual(error.localizedDescription, "Data found to be corrupted in JSON: data corrupted")
    }

    func test_invalid_data_error_equality() {
        XCTAssertEqual(APIError.invalidData, APIError.invalidData)
    }

    func test_response_unsuccessful_error_equality() {
        XCTAssertEqual(APIError.responseUnsuccessful, APIError.responseUnsuccessful)
    }

    func test_request_cancelled_error_equality() {
        XCTAssertEqual(APIError.requestCancelled, APIError.requestCancelled)
    }

    func test_key_not_found_error_equality() {
        let key1 = TestCodingKey(stringValue: "key1")
        let key2 = TestCodingKey(stringValue: "key1")
        let error1 = APIError.keyNotFound(key: key1, context: "context1")
        let error2 = APIError.keyNotFound(key: key2, context: "context1")
        XCTAssertEqual(error1, error2)
    }

    func test_value_not_found_error_equality() {
        let error1 = APIError.valueNotFound(type: Int.self, context: "context1")
        let error2 = APIError.valueNotFound(type: Int.self, context: "context1")
        XCTAssertEqual(error1, error2)
    }

    func test_type_mismatch_error_equality() {
        let error1 = APIError.typeMismatch(type: String.self, context: "context1")
        let error2 = APIError.typeMismatch(type: String.self, context: "context1")
        XCTAssertEqual(error1, error2)
    }

    func test_data_corrupted_error_equality() {
        let error1 = APIError.dataCorrupted(context: "context1")
        let error2 = APIError.dataCorrupted(context: "context1")
        XCTAssertEqual(error1, error2)
    }

    func test_key_not_found_error_inequality() {
        let key1 = TestCodingKey(stringValue: "key1")
        let key2 = TestCodingKey(stringValue: "key2")
        let error1 = APIError.keyNotFound(key: key1, context: "context1")
        let error2 = APIError.keyNotFound(key: key2, context: "context1")
        XCTAssertNotEqual(error1, error2)
    }

    func test_value_not_found_error_inequality() {
        let error1 = APIError.valueNotFound(type: Int.self, context: "context1")
        let error2 = APIError.valueNotFound(type: String.self, context: "context1")
        XCTAssertNotEqual(error1, error2)
    }

    func test_type_mismatch_error_inequality() {
        let error1 = APIError.typeMismatch(type: String.self, context: "context1")
        let error2 = APIError.typeMismatch(type: Int.self, context: "context1")
        XCTAssertNotEqual(error1, error2)
    }

    func test_data_corrupted_error_inequality() {
        let error1 = APIError.dataCorrupted(context: "context1")
        let error2 = APIError.dataCorrupted(context: "context2")
        XCTAssertNotEqual(error1, error2)
    }

    func test_error_inequality_for_different_error_types() {
        let error1 = APIError.invalidData
        let error2 = APIError.responseUnsuccessful
        XCTAssertNotEqual(error1, error2)
    }
}

struct TestCodingKey: CodingKey, CustomStringConvertible {
    var stringValue: String
    var intValue: Int? { return nil }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }

    var description: String {
        return stringValue
    }
}
