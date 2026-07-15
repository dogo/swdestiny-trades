//
//  NetworkingLoggerTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 24/08/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class NetworkingLoggerTests {

    private class TestOutputStream: TextOutputStream {
        private(set) var output: [String] = []

        func write(_ string: String) {
            output.append(string)
        }

        var joined: String {
            output.joined()
        }
    }

    private var logger: NetworkingLogger!
    private var testOutputStream: TestOutputStream!

    init() {
        testOutputStream = TestOutputStream()
        logger = NetworkingLogger(level: .debug, outputStream: testOutputStream)
    }

    deinit {
        logger = nil
        testOutputStream = nil
    }

    @Test
    func log_request() throws {
        var request = try URLRequest(url: #require(URL(string: "https://example.com")))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer token", forHTTPHeaderField: "Authorization")
        request.httpBody = Data("{\"key\": \"value\"}".utf8)
        logger.log(request: request)

        let output = testOutputStream.output.joined()
        #expect(output.contains("LOGGER | ───────────────────────────────────────────────────"))
        #expect(output.contains("LOGGER | 🚀 GET https://example.com"))
        #expect(output.contains("LOGGER | 📋 Headers:"))
        #expect(output.contains("LOGGER |    Authorization: Bearer token"))
        #expect(output.contains("LOGGER |    Content-Type: application/json"))
        #expect(output.contains("LOGGER | 📦 Body: {\"key\": \"value\"}"))
    }

    @Test
    func log_response() throws {
        let url = try #require(URL(string: "https://example.com"))
        let response = try #require(HTTPURLResponse(url: url,
                                                    statusCode: 200,
                                                    httpVersion: nil,
                                                    headerFields: nil))
        let data = Data("{\"key\": \"value\"}".utf8)
        logger.log(response: response, data: data, time: 1.234)

        let output = testOutputStream.output.joined()
        #expect(output.contains("LOGGER | ✅ 200 • 1.23s"))
        #expect(output.contains("LOGGER | 📄 Response:"))
        #expect(output.contains("LOGGER |    {"))
        #expect(output.contains("LOGGER |      \"key\" : \"value\""))
        #expect(output.contains("LOGGER |    }"))
        #expect(output.contains("LOGGER | ───────────────────────────────────────────────────"))
    }

    @Test
    func log_response_with_invalid_json() throws {
        let url = try #require(URL(string: "https://example.com"))
        let response = try #require(HTTPURLResponse(url: url,
                                                    statusCode: 200,
                                                    httpVersion: nil,
                                                    headerFields: nil))
        let data = Data("\"key\": \"value\"".utf8)
        logger.log(response: response, data: data, time: 1.234)

        let output = testOutputStream.output.joined()
        #expect(output.contains("LOGGER | ✅ 200 • 1.23s"))
        #expect(output.contains("LOGGER | 📄 Response: \"key\": \"value\""))
    }

    @Test
    func log_error() throws {
        let request = try URLRequest(url: #require(URL(string: "https://example.com")))
        let error = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        logger.logError(request: request, statusCode: 500, error: error)

        let output = testOutputStream.output.joined()
        #expect(output.contains("LOGGER | ───────────────────────────────────────────────────"))
        #expect(output.contains("LOGGER | 💥 500 GET https://example.com"))
        #expect(output.contains("LOGGER |    Test error"))
    }
}
