//
//  URLRequestTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 14/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class URLRequestTests: BaseTestCase {

    func test_init_with_URL_valid_URL_should_create_URLRequest() {
        let validURL = URL(string: "https://example.com")!

        let urlRequest = URLRequest(with: validURL)

        XCTAssertEqual(urlRequest.url, validURL, "URLRequest should have the correct URL.")
    }
}
