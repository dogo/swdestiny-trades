//
//  CardServiceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

final class CardServiceTests: BaseTestCase {

    private var sut: CardService!

    override init() async throws {
        try await super.init()
        sut = CardService(client: mockHttpClient)
    }

    @Test
    func retrieveSetCardListWithSuccess() async throws {
        mockHttpClient.fileName = "card-list"
        let result = try await sut.retrieveSetCardList(setCode: "anyString")

        #expect(result.isEmpty == false)
    }

    @Test
    func retrieveSpecificCardWithSuccess() async throws {
        mockHttpClient.fileName = "card"
        let result = try await sut.retrieveCard(cardId: "anyString")

        #expect(result.code == "01001")
    }

    @Test
    func retrieveAllCardsWithSuccess() async throws {
        mockHttpClient.fileName = "card-list"
        let result = try await sut.retrieveAllCards()

        #expect(result.isEmpty == false)
    }

    @Test
    func testCancelRequest() {
        let request = URLRequest(with: URL(string: "https://base.url.com"))
        sut.cancelRequest(request)

        #expect(mockHttpClient.isCancelled)
    }
}
