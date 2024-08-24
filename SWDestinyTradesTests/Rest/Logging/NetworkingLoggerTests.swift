//
//  NetworkingLoggerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class NetworkingLoggerTests: XCTestCase {

    private class TestOutputStream: TextOutputStream {
        private(set) var output: [String] = []

        func write(_ string: String) {
            output.append(string)
        }
    }

    private var logger: NetworkingLogger!
    private var testOutputStream: TestOutputStream!

    override func setUp() {
        super.setUp()
        testOutputStream = TestOutputStream()
        logger = NetworkingLogger(level: .debug, outputStream: testOutputStream)
    }

    override func tearDown() {
        logger = nil
        testOutputStream = nil
        super.tearDown()
    }

    func test_log_request() {
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer token", forHTTPHeaderField: "Authorization")
        request.httpBody = Data("{\"key\": \"value\"}".utf8)
        logger.log(request: request)

        XCTAssertTrue(testOutputStream.output.contains("LOGGER |---------------------------------------------------\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | GET 'https://example.com':\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | Headers: [\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER |   Authorization: Bearer token\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER |   Content-Type: application/json\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | ]\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | Body: {\"key\": \"value\"}\n"))
    }

    func test_log_response() {
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = Data("{\"key\": \"value\"}".utf8)
        logger.log(response: response, data: data, time: 1.234)

        XCTAssertTrue(testOutputStream.output.contains("LOGGER | 200 'https://example.com'\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | Duration: '00:00:01.234'\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | JSON:\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | {\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER |   \"key\" : \"value\"\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | }\n"))
    }

    func test_log_response_with_invalid_json() {
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = Data("\"key\": \"value\"".utf8)
        logger.log(response: response, data: data, time: 1.234)

        XCTAssertTrue(testOutputStream.output.contains("LOGGER | 200 'https://example.com'\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | Duration: '00:00:01.234'\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | \"key\": \"value\"\n"))
    }

    func test_log_error() {
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let error = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        logger.logError(request: request, statusCode: 500, error: error)

        XCTAssertTrue(testOutputStream.output.contains("LOGGER | [Error] 500 GET 'https://example.com':\n"))
        XCTAssertTrue(testOutputStream.output.contains("LOGGER | Description: Test error\n"))
    }
}
