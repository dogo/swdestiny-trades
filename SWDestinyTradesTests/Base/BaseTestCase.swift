//
//  BaseTestCase.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/08/25.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

class BaseTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        DependencyManager.shared.register(type: HttpClientProtocol.self) {
            HttpClientMock()
        }
    }

    override func tearDown() {
        DependencyManager.shared.remove(type: HttpClientProtocol.self)
        super.tearDown()
    }
}
