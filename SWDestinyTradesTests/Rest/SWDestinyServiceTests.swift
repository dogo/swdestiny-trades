//
//  SWDestinyServiceTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class SWDestinyServiceTests: BaseTestCase {

    private var sut: SWDestinyService!

    override init() async throws {
        try await super.init()
        sut = SWDestinyService(client: mockHttpClient)
    }

    @Test
    func testRetrieveSetListWithSuccess() async throws {
        mockHttpClient.fileName = "sets"
        let result = try await sut.retrieveSetList()

        #expect(result.isEmpty == false)
    }

    @Test
    func testRetrieveSetCardListWithSuccess() async throws {
        mockHttpClient.fileName = "card-list"
        let result = try await sut.retrieveSetCardList(setCode: "anyString")

        #expect(result.isEmpty == false)
    }

    @Test
    func testRetrieveSpecificCardWithSuccess() async throws {
        mockHttpClient.fileName = "card"
        let result = try await sut.retrieveCard(cardId: "anyString")

        #expect(result.code == "01001")
    }

    @Test
    func testRetrieveAllCardsWithSuccess() async throws {
        mockHttpClient.fileName = "card-list"
        let result = try await sut.retrieveAllCards()

        #expect(result.isEmpty == false)
    }

    @Test
    func testCancelRequest() {
        let request = URLRequest(with: URL(string: "https://base.url.com")!)
        sut.cancelRequest(request)

        #expect(mockHttpClient.isCancelled)
    }
}
