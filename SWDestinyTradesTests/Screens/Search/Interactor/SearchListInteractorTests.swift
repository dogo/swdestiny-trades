//
//  SearchListInteractorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 18/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import XCTest

@testable import SWDestinyTrades

final class SearchListInteractorTests: BaseTestCase {

    private var sut: SearchListInteractor!
    private var service: SWDestinyService!
    private var client: HttpClientMock!

    override func setUp() {
        super.setUp()
        client = DependencyManager.shared.resolve(type: HttpClientProtocol.self, mode: .shared) as? HttpClientMock
        service = SWDestinyService()
        sut = SearchListInteractor(service: service)
    }

    override func tearDown() {
        client = nil
        service = nil
        sut = nil
        super.tearDown()
    }

    func test_search_cards_with_success() async throws {
        client.fileName = "card-list"
        let cardList = try await sut.search(query: "panda")

        XCTAssertEqual(cardList.count, 22)
    }

    func test_fail_to_search_cards() async throws {
        client.error = true

        do {
            _ = try await sut.search(query: "panda")
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertNotNil(error, "error must be not-nil")
        }
    }
}
