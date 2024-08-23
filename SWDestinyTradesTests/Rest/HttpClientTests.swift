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
        request = URLRequest(with: URL(string: "https://base.url.com")!)
        request.httpMethod = HttpMethod.get.toString()
    }

    func test_request_with_success() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: Data("{ \"bar\": true }".utf8),
                         statusCode: 200)
        }

        let result = try await sut.request(request, decode: Foo.self)
        XCTAssertTrue(result.bar)
    }

    func test_request_with_failure_invalidData() async throws {
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)

        URLProtocolMock.response = { _ in
            return HTTPResponse(data: nil, statusCode: 200, isHTTP: false)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw APIError.invalidData, but succeeded.")
        } catch {
            XCTAssertEqual(error as? APIError, .invalidData, "Expected APIError.invalidData but got \(error)")
        }
    }

    func test_request_with_failure_responseUnsuccessful() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: nil, statusCode: 404)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIError, .responseUnsuccessful, "Expected APIError.responseUnsuccessful but got \(error)")
        }
    }

    func test_request_with_failure_requestCancelled() async throws {
        request = URLRequest(with: URL(string: "https://base.url.com")!)

        URLProtocolMock.response = { _ in
            throw URLError(.cancelled)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw APIError.requestCancelled, but succeeded.")
        } catch {
            XCTAssertEqual(error as? APIError, .requestCancelled, "Expected APIError.requestCancelled but got \(error)")
        }
    }

    func test_request_with_failure_keyNotFound() async throws {
        struct DummyResponse: Decodable {
            let id: Int
            let name: String
        }

        let missingKeyJson = Data("{ \"id\": 123 }".utf8)

        URLProtocolMock.response = { _ in
            return HTTPResponse(data: missingKeyJson, statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: DummyResponse.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            if let apiError = error as? APIError, case let .keyNotFound(key, context) = apiError {
                XCTAssertEqual(key.stringValue, "name", "Expected 'name' key to be missing.")
                XCTAssertTrue(context.contains("No value associated with key CodingKeys(stringValue: \"name\", intValue: nil) (\"name\")."), "Unexpected context message.")
            } else {
                XCTFail("Expected APIError.keyNotFound, but got \(error) instead.")
            }
        }
    }

    func test_request_with_failure_valueNotFound() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: Data("{ \"bar\": \"invalid_value\" }".utf8),
                         statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            // XCTAssertEqual(error as? APIError, .valueNotFound(type: Foo.self, context: "Value for 'Foo' could not be decoded."))
        }
    }

    func test_request_with_failure_typeMismatch() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: Data("{ \"bar\": \"invalid_value\" }".utf8),
                         statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIError, .typeMismatch(type: Bool.self, context: "Expected to decode Bool but found a string instead."))
        }
    }

    func test_request_with_failure_dataCorrupted() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: nil, statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIError, .dataCorrupted(context: "The given data was not valid JSON."), "Expected APIError.dataCorrupted but got \(error)")
        }
    }

    func test_cancelRequest() async {
        URLProtocolMock.response = { _ in
            return HTTPResponse(data: nil, statusCode: 200)
        }

        Task {
            _ = try? await sut.request(request, decode: Foo.self)
        }

        await Task.yield() // Allow the request to start

        XCTAssertEqual(sut.activeTasks?.count, 1, "Expected 1 active task before cancellation.")

        sut.cancelRequest(request)

        XCTAssertTrue(sut.activeTasks!.isEmpty, "Expected no active tasks after cancelling the request.")
    }
}

struct Foo: Codable {
    var bar: Bool

    enum CodingKeys: String, CodingKey {
        case bar
    }
}
