//
//  CardServiceMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class CardServiceMock: CardServiceProtocol {

    var httpClient: HttpClientProtocol

    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }

    var retrieveSetCardListResult: [CardDTO] = []
    var retrieveSetCardListError: Error?
    private(set) var retrieveSetCardListCallCount = 0
    func retrieveSetCardList(setCode: String) async throws -> [CardDTO] {
        retrieveSetCardListCallCount += 1
        if let error = retrieveSetCardListError {
            throw error
        }

        // If no pre-configured result is set, delegate to the HTTP client
        if retrieveSetCardListResult.isEmpty {
            let endpoint = CardListEndpoint(setCode: setCode)
            return try await httpClient.request(endpoint, decode: [CardDTO].self)
        }

        return retrieveSetCardListResult
    }

    var retrieveAllCardsResult: [CardDTO] = []
    var retrieveAllCardsError: Error?
    private(set) var retrieveAllCardsCallCount = 0
    func retrieveAllCards() async throws -> [CardDTO] {
        retrieveAllCardsCallCount += 1
        if let error = retrieveAllCardsError {
            throw error
        }
        return retrieveAllCardsResult
    }

    var retrieveCardResult: CardDTO?
    var retrieveCardError: Error?
    private(set) var retrieveCardCallCount = 0
    func retrieveCard(cardId: String) async throws -> CardDTO {
        retrieveCardCallCount += 1
        if let error = retrieveCardError {
            throw error
        }
        guard let result = retrieveCardResult else {
            throw NSError(domain: "CardServiceMock", code: 404, userInfo: [NSLocalizedDescriptionKey: "Card not found"])
        }
        return result
    }

    private(set) var cancelRequestCallCount = 0
    func cancelRequest(_ request: URLRequest?) {
        cancelRequestCallCount += 1
        httpClient.cancelRequest(request)
    }
}
