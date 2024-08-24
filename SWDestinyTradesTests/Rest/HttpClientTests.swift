//
//  HttpClientTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class HttpClientTests: XCTestCase {

    private var sut: HttpClient!
    private var session: URLSession!
    private var request: URLRequest!

    override func setUp() {
        super.setUp()
        session = URLSessionMock().build()
        sut = HttpClient(session: session)
        request = URLRequest(url: URL(string: "https://base.url.com")!)
        request.httpMethod = HttpMethod.get.toString()
    }

    override func tearDown() {
        sut = nil
        session = nil
        request = nil
        super.tearDown()
    }

    func test_request_with_success() async throws {
        setupURLProtocolMock(with: Data("{ \"bar\": true }".utf8), statusCode: 200)

        let result = try await sut.request(request, decode: Foo.self)
        XCTAssertTrue(result.bar)
    }

    func test_request_with_failure_invalidData() async throws {
        setupURLProtocolMock(with: nil, statusCode: 200, isHTTP: false)

        await assertThrowsError(of: .invalidData) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    func test_request_with_failure_responseUnsuccessful() async throws {
        setupURLProtocolMock(with: nil, statusCode: 404)

        await assertThrowsError(of: .responseUnsuccessful) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    func test_request_with_failure_requestCancelled() async throws {
        setupURLProtocolMock(with: nil, statusCode: 200, error: URLError(.cancelled))

        await assertThrowsError(of: .requestCancelled) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    func test_request_with_failure_keyNotFound() async throws {
        let missingKeyJson = Data("{ \"id\": 123 }".utf8)
        setupURLProtocolMock(with: missingKeyJson, statusCode: 200)

        await assertKeyNotFound(in: {
            _ = try await self.sut.request(self.request, decode: DummyResponse.self)
        }, missingKey: "name")
    }

    func test_request_with_failure_valueNotFound() async throws {
        let missingValueJson = Data("{ \"id\": 123, \"name\": null }".utf8)
        setupURLProtocolMock(with: missingValueJson, statusCode: 200)

        await assertValueNotFound(of: String.self) {
            _ = try await self.sut.request(self.request, decode: DummyResponse.self)
        }
    }

    func test_request_with_failure_typeMismatch() async throws {
        setupURLProtocolMock(with: Data("{ \"bar\": \"invalid_value\" }".utf8), statusCode: 200)

        await assertThrowsError(of: .typeMismatch(type: Bool.self, context: "Expected to decode Bool but found a string instead.")) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    func test_request_with_failure_dataCorrupted() async throws {
        setupURLProtocolMock(with: nil, statusCode: 200)

        await assertThrowsError(of: .dataCorrupted(context: "The given data was not valid JSON.")) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    func test_cancelRequest() async {
        setupURLProtocolMock(with: nil, statusCode: 200)

        Task {
            _ = try? await self.sut.request(self.request, decode: Foo.self)
        }

        await Task.yield() // Allow the request to start

        XCTAssertNoThrow(try {
            let activeTasksCount = try XCTUnwrap(self.sut.activeTasks).count
            XCTAssertEqual(activeTasksCount, 1, "Expected 1 active task before cancellation.")
        }())

        sut.cancelRequest(request)

        // Add a short delay to ensure the cancellation has taken effect
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNoThrow(try {
            let areTasksEmpty = try XCTUnwrap(self.sut.activeTasks).isEmpty
            XCTAssertTrue(areTasksEmpty, "Expected no active tasks after cancelling the request.")
        }())
    }

    // MARK: - Helper Methods

    private func setupURLProtocolMock(with data: Data?, statusCode: Int, isHTTP: Bool = true, error: Error? = nil) {
        URLProtocolMock.response = { _ in
            if let error {
                throw error
            }
            return HTTPResponse(data: data, statusCode: statusCode, isHTTP: isHTTP)
        }
    }

    private func assertThrowsError(of expectedError: APIError, in block: @escaping () async throws -> Void) async {
        do {
            try await block()
            XCTFail("Expected to throw \(expectedError), but succeeded.")
        } catch {
            XCTAssertEqual(error as? APIError, expectedError, "Expected \(expectedError) but got \(error) instead.")
        }
    }

    private func assertKeyNotFound(in block: @escaping () async throws -> Void, missingKey: String) async {
        do {
            try await block()
            XCTFail("Expected to throw APIError.keyNotFound, but succeeded.")
        } catch {
            if let apiError = error as? APIError, case let .keyNotFound(key, context) = apiError {
                XCTAssertEqual(key.stringValue, missingKey, "Expected '\(missingKey)' key to be missing.")
                XCTAssertTrue(context.contains("No value associated with key CodingKeys(stringValue: \"\(missingKey)\", intValue: nil) (\"\(missingKey)\")."), "Unexpected context message.")
            } else {
                XCTFail("Expected APIError.keyNotFound, but got \(error) instead.")
            }
        }
    }

    private func assertValueNotFound(of expectedType: (some Any).Type, in block: @escaping () async throws -> Void) async {
        do {
            try await block()
            XCTFail("Expected to throw APIError.valueNotFound, but succeeded.")
        } catch {
            if let apiError = error as? APIError, case let .valueNotFound(type, context) = apiError {
                XCTAssertEqual(String(describing: type), String(describing: expectedType), "Expected type \(expectedType) for the value.")
                XCTAssertTrue(context.contains("Cannot get unkeyed decoding container -- found null value instead"), "Unexpected context message: \(context)")
            } else {
                XCTFail("Expected APIError.valueNotFound, but got \(error) instead.")
            }
        }
    }
}

struct DummyResponse: Decodable {
    let id: Int
    let name: String
}

struct Foo: Codable {
    var bar: Bool
}
