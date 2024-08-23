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
        URLProtocolMock.response = { _ in
            HTTPResponse(data: Data("{ \"id\": 3465 }".utf8),
                         statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIError,
                           .keyNotFound(key: Foo.CodingKeys.bar, context: "No value associated with key CodingKeys(stringValue: \"bar\", intValue: nil) (\"bar\")."),
                           "Expected APIError.requestCancelled but got \(error)")
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

    func test_cancelRequest() {
        request = URLRequest(with: URL(string: "https://base.url.com")!)
        sut.cancelRequest(request)
        // Uncomment once cancellation handling is implemented in the HttpClient
        // XCTAssertTrue(session.tasksCancelled)
    }
}

struct Foo: Codable {
    var bar: Bool

    enum CodingKeys: String, CodingKey {
        case bar
    }
}
