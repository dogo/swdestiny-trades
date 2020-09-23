//
//  HttpClientTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 07/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
@testable import SWDestiny_Trades

final class HttpClientTests: QuickSpec {

    override func spec() {

        describe("HttpClient") {

            var sut: HttpClient!
            var session: URLSessionMock!
            var request: URLRequest!

            beforeEach {
                session = URLSessionMock()
                sut = HttpClient(session: session)
                request = URLRequest(with: URL(string: "https://base.url.com")!)
                request.httpMethod = HttpMethod.get.toString()
            }

            context("requesting with success") {

                it("using decode block") {

                    session.data = try JSONEncoder().encode(true)

                    sut.request(request, decode: { json -> Bool in
                        let reverse = !json
                        return reverse
                    }, completion: { result in
                        if case .success(let boolean) = result {
                            expect(boolean) == false
                        } else {
                            fail("Should be a success result")
                        }
                    })
                }

                it("without decode block") {

                    session.data = try JSONEncoder().encode(true)

                    sut.request(request) { (result: Result<Bool, APIError>) in
                        if case .success(let boolean) = result {
                            expect(boolean) == true
                        } else {
                            fail("Should be a success result")
                        }
                    }
                }
            }

            context("requesting with failure") {

                it("with response unsuccessful") {

                    session.statusCode = 404

                    sut.request(request, decode: { json -> Bool in
                        return json
                    }, completion: { result in
                        if case .failure(let error) = result {
                            expect(error.localizedDescription) == "Response Unsuccessful"
                        } else {
                            fail("Should be a failure result")
                        }
                    })
                }

                it("with response json conversion failure") {

                    session.data = "{ \"id\": 3465 }".data(using: .utf8)

                    sut.request(request, decode: { json -> Bool in
                        return json
                    }, completion: { result in
                        if case .failure(let error) = result {
                            expect(error.localizedDescription) == "JSON Conversion Failure"
                        } else {
                            fail("Should be a failure result")
                        }
                    })
                }

                it("with response Invalid data") {

                    session.data = nil

                    sut.request(request, decode: { json -> Bool in
                        return json
                    }, completion: { result in
                        if case .failure(let error) = result {
                            expect(error.localizedDescription) == "Invalid Data"
                        } else {
                            fail("Should be a failure result")
                        }
                    })
                }

                it("with cancelled error") {

                    session.response = nil
                    session.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)

                    sut.request(request) { (result: Result<Bool, APIError>) in
                        if case .failure(let error) = result {
                            expect(error.localizedDescription) == "Request Cancelled"
                        } else {
                            fail("Should be a failure result")
                        }
                    }
                }

                it("with server error reason") {

                    session.response = nil
                    session.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnsupportedURL, userInfo: nil)

                    sut.request(request) { (result: Result<Bool, APIError>) in
                        if case .failure(let error) = result {
                            expect(error.localizedDescription) == "The operation couldn’t be completed"
                        } else {
                            fail("Should be a failure result")
                        }
                    }
                }
            }

            it("should cancel all requests") {

                sut.cancelAllRequests()
                expect(session.tasksCancelled) == true
            }
        }
    }
}
