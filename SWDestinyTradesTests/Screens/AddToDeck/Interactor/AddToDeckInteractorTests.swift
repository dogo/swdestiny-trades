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

final class AddToDeckInteractorTests: BaseTestCase {

    private var sut: AddToDeckInteractor!
    private var service: SWDestinyService!
    private var client: HttpClientMock!

    override func setUp() {
        super.setUp()
        client = DependencyManager.shared.resolve(type: HttpClientProtocol.self, mode: .shared) as? HttpClientMock
        service = SWDestinyService()
        sut = AddToDeckInteractor(service: service)
    }

    override func tearDown() {
        client = nil
        service = nil
        sut = nil
        super.tearDown()
    }

    func test_fetchAllCards() async throws {
        client.fileName = "card-list"
        let cards = try await sut.fetchAllCards()

        XCTAssertEqual(cards.count, 22)
    }
}
