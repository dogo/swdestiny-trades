//
//  HttpClientTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import SWDestinyTrades

final class HttpClientTests: AsyncSpec {

    override class func spec() {

        describe("HttpClient") {
            var sut: HttpClient!
            var session: URLSession!
            var request: URLRequest!

            beforeEach {
                session = URLSessionMock().build()
                sut = HttpClient(session: session)
                request = URLRequest(with: URL(string: "https://base.url.com")!)
                request.httpMethod = HttpMethod.get.toString()
            }

            context("requesting with success") {

                it("should decode with success") {
                    URLProtocolMock.response = { _ in
                        HTTPResponse(data: "{ \"bar\": true }".data(using: .utf8),
                                     statusCode: 200)
                    }

                    await expect { try? await sut.request(request, decode: Foo.self).bar } == true
                }
            }

            context("requesting with failure") {

                it("with response unsuccessful") {
                    URLProtocolMock.response = { _ in
                        HTTPResponse(statusCode: 404)
                    }

                    await expect {
                        try await sut.request(request, decode: Foo.self)
                    }.to(throwError(APIError.responseUnsuccessful))
                }

                xit("with response json conversion failure") {
                    URLProtocolMock.response = { _ -> HTTPResponse in
                        HTTPResponse(data: "{ \"id\": 3465 }".data(using: .utf8),
                                     statusCode: 200)
                    }

                    await expect {
                        try await sut.request(request, decode: Foo.self)
                    }.to(throwError(APIError.jsonConversionFailure(domain: "j", description: "j")))
                }

                xit("with response invalid data") {
                    URLProtocolMock.response = { _ in
                        HTTPResponse(statusCode: 200)
                    }

                    await expect {
                        try await sut.request(request, decode: Foo.self)
                    }.to(throwError(APIError.invalidData))
                }

                it("with response data corrupted") {
                    URLProtocolMock.response = { _ in
                        HTTPResponse(statusCode: 200)
                    }

                    await expect {
                        try await sut.request(request, decode: Foo.self)
                    }.to(throwError(APIError.dataCorrupted(context: "The given data was not valid JSON.")))
                }

                it("with cancelled error") {
//                    session.response = nil
//                    session.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                    URLProtocolMock.response = { _ in
                        HTTPResponse(statusCode: 200)
                    }

//                    await expect {
//                        try await sut.request(request, decode: Foo.self)
//                    }.to(throwError(APIError.requestCancelled))
                }

                it("with server error reason") {
//                    session.response = nil
//                    session.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnsupportedURL, userInfo: nil)
//
//                    sut.request(request) { (result: Result<Bool, APIError>) in
//                        if case let .failure(error) = result {
//                            expect(error.localizedDescription) == "Request failed with reason: The operation couldn’t be completed. (NSURLErrorDomain error -1002.)"
//                        } else {
//                            fail("Should be a failure result")
//                        }
//                    }
                }
            }

            it("should cancel all requests") {
                sut.cancelAllRequests()
                // expect(session.tasksCancelled) == true
            }
        }
    }
}

struct Foo: Decodable {
    var bar: Bool
}
