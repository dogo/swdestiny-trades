//
//  AddToDeckInteractorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 02/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import UIKit
import XCTest

@testable import SWDestinyTrades

final class AddToDeckInteractorTests: XCTestCase {

    private var sut: AddToDeckInteractor!
    private var service: SWDestinyService!
    private var client: HttpClientMock!

    override func setUp() {
        super.setUp()
        client = HttpClientMock()
        service = SWDestinyService(client: client)
        sut = AddToDeckInteractor(service: service)
    }

    override func tearDown() {
        client = nil
        service = nil
        sut = nil
        super.tearDown()
    }

    func test_retrieveAllCards() async throws {
        let cards = try await sut.retrieveAllCards()

        XCTAssertNotNil(cards)
    }
}
