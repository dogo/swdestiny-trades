//
//  SWDestinyServiceTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class SWDestinyServiceTests: XCTestCase {

    private var sut: SWDestinyService!
    private var client: HttpClientMock!

    override func setUp() {
        super.setUp()
        client = HttpClientMock()
        sut = SWDestinyService(client: client)
    }

    func testRetrieveSetListWithSuccess() async throws {
        client.fileName = "sets"
        let result = try await sut.retrieveSetList()

        XCTAssertNotNil(result)
    }

    func testRetrieveSetCardListWithSuccess() async throws {
        client.fileName = "card-list"
        let result = try await sut.retrieveSetCardList(setCode: "anyString")

        XCTAssertNotNil(result)
    }

    func testRetrieveSpecificCardWithSuccess() async throws {
        client.fileName = "card"
        let result = try await sut.retrieveCard(cardId: "anyString")

        XCTAssertNotNil(result)
    }

    func testRetrieveAllCardsWithSuccess() async throws {
        client.fileName = "card-list"
        let result = try await sut.retrieveAllCards()

        XCTAssertNotNil(result)
    }

    func testCancelRequest() {
        let request = URLRequest(with: URL(string: "https://base.url.com")!)
        sut.cancelRequest(request)

        XCTAssertTrue(client.isCancelled)
    }
}
