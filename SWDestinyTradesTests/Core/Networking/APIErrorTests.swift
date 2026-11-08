//
//  APIErrorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 04/09/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class APIErrorTests {

    @Test
    func invalid_data_error_description() {
        let error = APIError.invalidData
        #expect(error.localizedDescription == "Invalid Data")
    }

    @Test
    func response_unsuccessful_error_description() {
        let error = APIError.responseUnsuccessful
        #expect(error.localizedDescription == "Response Unsuccessful")
    }

    @Test
    func request_cancelled_error_description() {
        let error = APIError.requestCancelled
        #expect(error.localizedDescription == "Request Cancelled")
    }

    @Test
    func key_not_found_error_description() {
        let key = TestCodingKey(stringValue: "testKey")
        let error = APIError.keyNotFound(key: key, context: "missing key")
        #expect(error.localizedDescription == "Could not find key testKey in JSON: missing key")
    }

    @Test
    func value_not_found_error_description() {
        let error = APIError.valueNotFound(type: Int.self, context: "missing value")
        #expect(error.localizedDescription == "Could not find type Int in JSON: missing value")
    }

    @Test
    func type_mismatch_error_description() {
        let error = APIError.typeMismatch(type: String.self, context: "type mismatch")
        #expect(error.localizedDescription == "Type mismatch for type String in JSON: type mismatch")
    }

    @Test
    func data_corrupted_error_description() {
        let error = APIError.dataCorrupted(context: "data corrupted")
        #expect(error.localizedDescription == "Data found to be corrupted in JSON: data corrupted")
    }

    @Test
    func invalid_data_error_equality() {
        let error1 = APIError.invalidData
        let error2 = APIError.invalidData
        #expect(error1 == error2)
    }

    @Test
    func response_unsuccessful_error_equality() {
        let error1 = APIError.responseUnsuccessful
        let error2 = APIError.responseUnsuccessful
        #expect(error1 == error2)
    }

    @Test
    func request_cancelled_error_equality() {
        let error1 = APIError.requestCancelled
        let error2 = APIError.requestCancelled
        #expect(error1 == error2)
    }

    @Test
    func key_not_found_error_equality() {
        let key1 = TestCodingKey(stringValue: "key1")
        let key2 = TestCodingKey(stringValue: "key1")
        let error1 = APIError.keyNotFound(key: key1, context: "context1")
        let error2 = APIError.keyNotFound(key: key2, context: "context1")
        #expect(error1 == error2)
    }

    @Test
    func value_not_found_error_equality() {
        let error1 = APIError.valueNotFound(type: Int.self, context: "context1")
        let error2 = APIError.valueNotFound(type: Int.self, context: "context1")
        #expect(error1 == error2)
    }

    @Test
    func type_mismatch_error_equality() {
        let error1 = APIError.typeMismatch(type: String.self, context: "context1")
        let error2 = APIError.typeMismatch(type: String.self, context: "context1")
        #expect(error1 == error2)
    }

    @Test
    func data_corrupted_error_equality() {
        let error1 = APIError.dataCorrupted(context: "context1")
        let error2 = APIError.dataCorrupted(context: "context1")
        #expect(error1 == error2)
    }

    @Test
    func key_not_found_error_inequality() {
        let key1 = TestCodingKey(stringValue: "key1")
        let key2 = TestCodingKey(stringValue: "key2")
        let error1 = APIError.keyNotFound(key: key1, context: "context1")
        let error2 = APIError.keyNotFound(key: key2, context: "context1")
        #expect(error1 != error2)
    }

    @Test
    func value_not_found_error_inequality() {
        let error1 = APIError.valueNotFound(type: Int.self, context: "context1")
        let error2 = APIError.valueNotFound(type: String.self, context: "context1")
        #expect(error1 != error2)
    }

    @Test
    func type_mismatch_error_inequality() {
        let error1 = APIError.typeMismatch(type: String.self, context: "context1")
        let error2 = APIError.typeMismatch(type: Int.self, context: "context1")
        #expect(error1 != error2)
    }

    @Test
    func data_corrupted_error_inequality() {
        let error1 = APIError.dataCorrupted(context: "context1")
        let error2 = APIError.dataCorrupted(context: "context2")
        #expect(error1 != error2)
    }

    @Test
    func error_inequality_for_different_error_types() {
        let error1 = APIError.invalidData
        let error2 = APIError.responseUnsuccessful
        #expect(error1 != error2)
    }
}

struct TestCodingKey: CodingKey, CustomStringConvertible {
    var stringValue: String
    var intValue: Int? {
        return nil
    }

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
