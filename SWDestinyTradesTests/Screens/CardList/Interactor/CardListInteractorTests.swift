//
//  CardListInteractorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 03/02/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class CardListInteractorTests: XCTestCase {

    private var sut: CardListInteractor!
    private var service: SWDestinyService!
    private var client: HttpClientMock!

    override func setUpWithError() throws {
        client = HttpClientMock()
        service = SWDestinyService(client: client)
        sut = CardListInteractor(service: service)
    }

    override func tearDownWithError() throws {
        client = nil
        service = nil
        sut = nil
    }

    func test_retrieve_sets_with_success() async throws {
        client.fileName = "card-list"
        let cards = try await sut.retrieveCards(setCode: "code")

        XCTAssertEqual(cards.count, 20)
    }

    func test_fail_to_retrieve_sets() async throws {
        client.error = true

        do {
            _ = try await sut.retrieveCards(setCode: "code")
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertNotNil(error, "error must be not-nil")
        }
    }
}
