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

    func testRequestWithSuccess() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: "{ \"bar\": true }".data(using: .utf8),
                         statusCode: 200)
        }

        let result = try await sut.request(request, decode: Foo.self)
        XCTAssertTrue(result.bar)
    }

    func testRequestWithFailureInvalidData() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            // XCTAssertEqual(error as? APIError, .invalidData)
        }
    }

    func testRequestWithFailureResponseUnsuccessful() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 404)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIError, .responseUnsuccessful)
        }
    }

    func testRequestWithFailureRequestCancelled() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            // XCTAssertEqual(error as? APIError, .requestCancelled)
        }
    }

    func testRequestWithFailureKeyNotFound() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: "{ \"id\": 3465 }".data(using: .utf8),
                         statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch let error as APIError {
            XCTAssertEqual(error, .keyNotFound(key: Foo.CodingKeys.bar,
                                               context: "No value associated with key CodingKeys(stringValue: \"bar\", intValue: nil) (\"bar\")."))
        }
    }

    func testRequestWithFailureValueNotFound() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: "{ \"bar\": \"invalid_value\" }".data(using: .utf8),
                         statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            // XCTAssertEqual(error as? APIError, .typeMismatch(type: Bool.self, context: "Expected to decode Bool but found a string instead."))
        }
    }

    func testRequestWithFailureTypeMismatch() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: "{ \"bar\": \"invalid_value\" }".data(using: .utf8),
                         statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIError, .typeMismatch(type: Bool.self, context: "Expected to decode Bool but found a string instead."))
        }
    }

    func testRequestWithFailureDataCorrupted() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 200)
        }

        do {
            _ = try await sut.request(request, decode: Foo.self)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIError, .dataCorrupted(context: "The given data was not valid JSON."))
        }
    }

    func testCancelAllRequests() {
        sut.cancelAllRequests()
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
