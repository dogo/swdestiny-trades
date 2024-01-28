//
//  DispatchQueueTypeTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 28/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class DispatchQueueTypeTests: XCTestCase {

    func testAsync() {

        let expectation = XCTestExpectation(description: "async expectation")
        let queue = DispatchQueue(label: "testQueue")

        queue.async {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testGlobalAsync() {

        let expectation = XCTestExpectation(description: "globalAsync expectation")
        let queue = DispatchQueue(label: "testQueue")

        queue.globalAsync {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
