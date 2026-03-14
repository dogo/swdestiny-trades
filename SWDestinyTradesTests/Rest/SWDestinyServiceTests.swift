//
//  SWDestinyServiceTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import XCTest

@testable import SWDestinyTrades

final class SWDestinyServiceTests: BaseTestCase {

    private var sut: SWDestinyService!

    override func setUp() async throws {
        try await super.setUp()
        sut = SWDestinyService(client: mockHttpClient)
    }

    func testRetrieveSetListWithSuccess() async throws {
        mockHttpClient.fileName = "sets"
        let result = try await sut.retrieveSetList()

        XCTAssertNotNil(result)
    }

    func testRetrieveSetCardListWithSuccess() async throws {
        mockHttpClient.fileName = "card-list"
        let result = try await sut.retrieveSetCardList(setCode: "anyString")

        XCTAssertNotNil(result)
    }

    func testRetrieveSpecificCardWithSuccess() async throws {
        mockHttpClient.fileName = "card"
        let result = try await sut.retrieveCard(cardId: "anyString")

        XCTAssertNotNil(result)
    }

    func testRetrieveAllCardsWithSuccess() async throws {
        mockHttpClient.fileName = "card-list"
        let result = try await sut.retrieveAllCards()

        XCTAssertNotNil(result)
    }

    func testCancelRequest() throws {
        let request = try URLRequest(with: XCTUnwrap(URL(string: "https://base.url.com")))
        sut.cancelRequest(request)

        XCTAssertTrue(mockHttpClient.isCancelled)
    }
}
