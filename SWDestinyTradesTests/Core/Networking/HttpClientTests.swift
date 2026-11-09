//
//  HttpClientTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation
import os
import Testing

@testable import SWDestinyTrades

@MainActor
@Suite(.serialized)
final class HttpClientTests {

    private var sut: HttpClient!
    private var session: URLSession!
    private var keychain: KeychainStoreMock!
    private let endpoint = SetListEndpoint()

    init() {
        session = URLSessionMock().build()
        keychain = KeychainStoreMock()
        sut = HttpClient(session: session, keychain: keychain)
    }

    isolated deinit {
        sut = nil
        session = nil
        keychain = nil
    }

    @Test
    func request_with_success() async throws {
        setupURLProtocolMock(with: Data("{ \"bar\": true }".utf8), statusCode: 200)

        let result = try await sut.request(endpoint, decode: Foo.self)
        #expect(result.bar)
    }

    @Test
    func request_with_failure_invalidData() async {
        setupURLProtocolMock(with: nil, statusCode: 200, isHTTP: false)

        await assertThrowsError(of: .invalidData) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_responseUnsuccessful() async {
        setupURLProtocolMock(with: nil, statusCode: 404)

        await assertThrowsError(of: .responseUnsuccessful) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_multipleChoices() async {
        setupURLProtocolMock(with: Data("{ \"bar\": true }".utf8), statusCode: 300)

        await assertThrowsError(of: .responseUnsuccessful) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_badRequest() async {
        let body = Data("{ \"error\": \"invalid_grant\" }".utf8)
        setupURLProtocolMock(with: body, statusCode: 400)

        await assertThrowsError(of: .badRequest(body)) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_serverError() async {
        setupURLProtocolMock(with: nil, statusCode: 503)

        await assertThrowsError(of: .serverError) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_requestCancelled() async {
        setupURLProtocolMock(with: nil, statusCode: 200, error: URLError(.cancelled))

        await assertThrowsError(of: .requestCancelled) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_keyNotFound() async {
        let missingKeyJson = Data("{ \"id\": 123 }".utf8)
        setupURLProtocolMock(with: missingKeyJson, statusCode: 200)

        await assertKeyNotFound(in: {
            _ = try await self.sut.request(self.endpoint, decode: DummyResponse.self)
        }, missingKey: "name")
    }

    @Test
    func request_with_failure_valueNotFound() async {
        let missingValueJson = Data("{ \"id\": 123, \"name\": null }".utf8)
        setupURLProtocolMock(with: missingValueJson, statusCode: 200)

        await assertValueNotFound(of: String.self) {
            _ = try await self.sut.request(self.endpoint, decode: DummyResponse.self)
        }
    }

    @Test
    func request_with_failure_typeMismatch() async {
        setupURLProtocolMock(with: Data("{ \"bar\": \"invalid_value\" }".utf8), statusCode: 200)

        await assertThrowsError(of: .typeMismatch(type: Bool.self, context: "Expected to decode Bool but found a string instead.")) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_with_failure_dataCorrupted() async {
        setupURLProtocolMock(with: nil, statusCode: 200)

        await assertThrowsError(of: .dataCorrupted(context: "The given data was not valid JSON.")) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    @Test
    func request_decodesOffTheMainThread() async throws {
        setupURLProtocolMock(with: Data("{ \"value\": 42 }".utf8), statusCode: 200)

        let probe = try await sut.request(endpoint, decode: DecodingThreadProbe.self)

        #expect(probe.decodedOnMainThread == false)
        #expect(probe.value == 42)
        probe.value += 1
        #expect(probe.value == 43)
    }

    @Test
    func request_hitsNetworkOnce() async throws {
        var hits = 0
        URLProtocolMock.response = { _ in
            hits += 1
            return HTTPResponse(data: Data("{ \"bar\": true }".utf8), statusCode: 200)
        }

        _ = try await sut.request(endpoint, decode: Foo.self)

        #expect(hits == 1)
    }

    @Test
    func requestEndpoint_needingToken_attachesBearer() async throws {
        let authorization = try await sentAuthorization(for: DecksEndpoint())

        #expect(authorization == "Bearer access")
    }

    @Test
    func requestEndpoint_notNeedingToken_omitsBearer() async throws {
        let authorization = try await sentAuthorization(for: SetListEndpoint())

        #expect(authorization == nil)
    }

    @Test
    func requestEndpoint_needingTokenWithoutStoredToken_omitsBearer() async throws {
        var authorization: String?
        URLProtocolMock.response = { request in
            authorization = request.value(forHTTPHeaderField: "Authorization")
            return HTTPResponse(data: Data("{ \"bar\": true }".utf8), statusCode: 200)
        }

        _ = try await sut.request(DecksEndpoint(), decode: Foo.self)

        #expect(authorization == nil)
    }

    @Test
    func request_unauthorized_throwsUnauthorized() async {
        setupURLProtocolMock(with: nil, statusCode: 401)

        await assertThrowsError(of: .unauthorized) {
            _ = try await self.sut.request(self.endpoint, decode: Foo.self)
        }
    }

    private func sentAuthorization(for endpoint: EndpointProtocol) async throws -> String? {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        var authorization: String?
        URLProtocolMock.response = { request in
            authorization = request.value(forHTTPHeaderField: "Authorization")
            return HTTPResponse(data: Data("{ \"bar\": true }".utf8), statusCode: 200)
        }

        _ = try await sut.request(endpoint, decode: Foo.self)

        return authorization
    }

    @Test
    func test_cancelRequest() async throws {
        setupURLProtocolMock(with: nil, statusCode: 200, delay: 1.0)

        let requestTask = Task {
            _ = try? await self.sut.request(self.endpoint, decode: Foo.self)
        }

        try? await Task.sleep(for: .milliseconds(100))

        let activeTasksCount = try #require(sut.activeTasks).count
        #expect(activeTasksCount == 1, "Expected 1 active task before cancellation.")

        sut.cancelRequest(endpoint.request)

        // Add a short delay to ensure the cancellation has taken effect
        try? await Task.sleep(for: .milliseconds(100))

        let areTasksEmpty = try #require(sut.activeTasks).isEmpty
        #expect(areTasksEmpty, "Expected no active tasks after cancelling the request.")

        requestTask.cancel()
    }

    @Test
    func cancelRequest_withAuthenticatedEndpoint_cancelsRequest() async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        setupURLProtocolMock(with: nil, statusCode: 200, delay: 1.0)
        let endpoint = DecksEndpoint()

        let request = Task { try await self.sut.request(endpoint, decode: Foo.self) }
        try await waitUntil { self.sut.activeTasks?[endpoint.request]?.count == 1 }
        sut.cancelRequest(endpoint.request)

        await assertThrowsError(of: .requestCancelled) {
            _ = try await request.value
        }
    }

    @Test
    func cancelRequest_afterIdenticalRequestFinishes_cancelsTheOther() async throws {
        let calls = OSAllocatedUnfairLock(initialState: 0)
        URLProtocolMock.response = { _ in
            let call = calls.withLock { count in
                count += 1
                return count
            }
            Thread.sleep(forTimeInterval: call == 1 ? 0.2 : 2.0)
            return HTTPResponse(data: Data("{ \"bar\": true }".utf8), statusCode: 200)
        }

        let requests = (0 ..< 2).map { _ in
            Task { () -> Error? in
                do {
                    _ = try await self.sut.request(self.endpoint, decode: Foo.self)
                    return nil
                } catch {
                    return error
                }
            }
        }
        try await waitUntil { self.sut.activeTasks?[self.endpoint.request]?.count == 2 }
        try await waitUntil { self.sut.activeTasks?[self.endpoint.request]?.count == 1 }
        sut.cancelRequest(endpoint.request)

        var errors: [APIError] = []
        for request in requests {
            if let error = await request.value {
                try errors.append(#require(error as? APIError))
            }
        }
        #expect(errors == [.requestCancelled])
    }

    private func waitUntil(_ condition: () -> Bool) async throws {
        let deadline = ContinuousClock.now + .seconds(5)
        while !condition() {
            try #require(ContinuousClock.now < deadline, "Condition not met within 5 seconds")
            try await Task.sleep(for: .milliseconds(10))
        }
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

final nonisolated class DecodingThreadProbe: Decodable {
    let decodedOnMainThread: Bool
    var value: Int

    private enum CodingKeys: String, CodingKey {
        case value
    }

    init(from decoder: Decoder) throws {
        decodedOnMainThread = Thread.isMainThread
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(Int.self, forKey: .value)
    }
}

struct Foo: Codable {
    var bar: Bool
}
