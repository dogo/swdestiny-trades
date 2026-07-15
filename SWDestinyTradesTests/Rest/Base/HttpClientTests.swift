//
//  HttpClientTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class HttpClientTests {

    private var sut: HttpClient!
    private var session: URLSession!
    private var request: URLRequest!

    init() {
        session = URLSessionMock().build()
        sut = HttpClient(session: session)
        request = URLRequest(url: URL(string: "https://base.url.com")!)
        request.httpMethod = HttpMethod.get.toString()
    }

    deinit {
        sut = nil
        session = nil
        request = nil
    }

    @Test
    func request_with_success() async throws {
        setupURLProtocolMock(with: Data("{ \"bar\": true }".utf8), statusCode: 200)

        let result = try await sut.request(request, decode: Foo.self)
        #expect(result.bar)
    }

    @Test
    func request_with_failure_invalidData() async {
        setupURLProtocolMock(with: nil, statusCode: 200, isHTTP: false)

        await assertThrowsError(of: .invalidData) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_responseUnsuccessful() async {
        setupURLProtocolMock(with: nil, statusCode: 404)

        await assertThrowsError(of: .responseUnsuccessful) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_requestCancelled() async {
        setupURLProtocolMock(with: nil, statusCode: 200, error: URLError(.cancelled))

        await assertThrowsError(of: .requestCancelled) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_keyNotFound() async {
        let missingKeyJson = Data("{ \"id\": 123 }".utf8)
        setupURLProtocolMock(with: missingKeyJson, statusCode: 200)

        await assertKeyNotFound(in: {
            _ = try await self.sut.request(self.request, decode: DummyResponse.self)
        }, missingKey: "name")
    }

    @Test
    func request_with_failure_valueNotFound() async {
        let missingValueJson = Data("{ \"id\": 123, \"name\": null }".utf8)
        setupURLProtocolMock(with: missingValueJson, statusCode: 200)

        await assertValueNotFound(of: String.self) {
            _ = try await self.sut.request(self.request, decode: DummyResponse.self)
        }
    }

    @Test
    func request_with_failure_typeMismatch() async {
        setupURLProtocolMock(with: Data("{ \"bar\": \"invalid_value\" }".utf8), statusCode: 200)

        await assertThrowsError(of: .typeMismatch(type: Bool.self, context: "Expected to decode Bool but found a string instead.")) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_dataCorrupted() async {
        setupURLProtocolMock(with: nil, statusCode: 200)

        await assertThrowsError(of: .dataCorrupted(context: "The given data was not valid JSON.")) {
            _ = try await self.sut.request(self.request, decode: Foo.self)
        }
    }

    @Test
    func test_cancelRequest() async throws {
        setupURLProtocolMock(with: nil, statusCode: 200, delay: 1.0)

        let requestTask = Task {
            _ = try? await self.sut.request(self.request, decode: Foo.self)
        }

        try? await Task.sleep(for: .milliseconds(100))

        let activeTasksCount = try #require(sut.activeTasks).count
        #expect(activeTasksCount == 1, "Expected 1 active task before cancellation.")

        sut.cancelRequest(request)

        // Add a short delay to ensure the cancellation has taken effect
        try? await Task.sleep(for: .milliseconds(100))

        let areTasksEmpty = try #require(sut.activeTasks).isEmpty
        #expect(areTasksEmpty, "Expected no active tasks after cancelling the request.")

        requestTask.cancel()
    }

    // MARK: - Helper Methods

    private func setupURLProtocolMock(with data: Data?, statusCode: Int, isHTTP: Bool = true, error: Error? = nil, delay: TimeInterval = 0) {
        URLProtocolMock.response = { _ in
            if delay > 0 {
                Thread.sleep(forTimeInterval: delay)
            }
            if let error {
                throw error
            }
            return HTTPResponse(data: data, statusCode: statusCode, isHTTP: isHTTP)
        }
    }

    private func assertThrowsError(of expectedError: APIError, in block: @escaping () async throws -> Void) async {
        do {
            try await block()
            Issue.record("Expected to throw \(expectedError), but succeeded.")
        } catch {
            #expect(error as? APIError == expectedError, "Expected \(expectedError) but got \(error) instead.")
        }
    }

    private func assertKeyNotFound(in block: @escaping () async throws -> Void, missingKey: String) async {
        do {
            try await block()
            Issue.record("Expected to throw APIError.keyNotFound, but succeeded.")
        } catch {
            if let apiError = error as? APIError, case let .keyNotFound(key, context) = apiError {
                #expect(key.stringValue == missingKey, "Expected '\(missingKey)' key to be missing.")
                #expect(context.contains("No value associated with key CodingKeys(stringValue: \"\(missingKey)\", intValue: nil) (\"\(missingKey)\")."), "Unexpected context message.")
            } else {
                Issue.record("Expected APIError.keyNotFound, but got \(error) instead.")
            }
        }
    }

    private func assertValueNotFound(of expectedType: (some Any).Type, in block: @escaping () async throws -> Void) async {
        do {
            try await block()
            Issue.record("Expected to throw APIError.valueNotFound, but succeeded.")
        } catch {
            if let apiError = error as? APIError, case let .valueNotFound(type, context) = apiError {
                #expect(String(describing: type) == String(describing: expectedType), "Expected type \(expectedType) for the value.")
                #expect(context.contains("Cannot get value of type String -- found null value instead"), "Unexpected context message: \(context)")
            } else {
                Issue.record("Expected APIError.valueNotFound, but got \(error) instead.")
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
