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

    func testRequestWithFailureResponseUnsuccessful() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 404)
        }

        // await XCTAssertThrowsError(try await sut.request(request, decode: Foo.self), "responseUnsuccessful")
    }

    func testRequestWithFailureJsonConversionFailure() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(data: "{ \"id\": 3465 }".data(using: .utf8),
                         statusCode: 200)
        }

        // await XCTAssertThrowsError(try await sut.request(request, decode: Foo.self), "jsonConversionFailure")
    }

    func testRequestWithFailureInvalidData() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 200)
        }

        // await XCTAssertThrowsError(try await sut.request(request, decode: Foo.self), "invalidData")
    }

    func testRequestWithFailureDataCorrupted() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 200)
        }

        // await XCTAssertThrowsError(try await sut.request(request, decode: Foo.self), "dataCorrupted")
    }

    func testRequestWithFailureRequestCancelled() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 200)
        }

        // Uncomment once cancellation handling is implemented in the HttpClient
        // await XCTAssertThrowsError(try await sut.request(request, decode: Foo.self), "requestCancelled")
    }

    func testRequestWithFailureServerErrorReason() async throws {
        URLProtocolMock.response = { _ in
            HTTPResponse(statusCode: 200)
        }

        // Uncomment once server error reason handling is implemented in the HttpClient
        // await XCTAssertThrowsError(try await sut.request(request, decode: Foo.self), "serverErrorReason")
    }

    func testCancelAllRequests() {
        sut.cancelAllRequests()
        // Uncomment once cancellation handling is implemented in the HttpClient
        // XCTAssertTrue(session.tasksCancelled)
    }
}

struct Foo: Decodable {
    var bar: Bool
}
