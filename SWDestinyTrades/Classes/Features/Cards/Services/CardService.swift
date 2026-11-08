//
//  CardService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

final class CardService: CardServiceProtocol {

    private let client: HttpClientProtocol

    init(client: HttpClientProtocol) {
        self.client = client
    }

    func retrieveSetCardList(setCode: String) async throws -> [CardDTO] {
        let endpoint = CardListEndpoint(setCode: setCode)

        return try await client.request(endpoint, decode: [CardDTO].self)
    }

    func retrieveAllCards() async throws -> [CardDTO] {
        let endpoint = AllCardsEndpoint()

        return try await client.request(endpoint, decode: [CardDTO].self)
    }

    func retrieveCard(cardId: String) async throws -> CardDTO {
        let endpoint = CardEndpoint(cardId: cardId)

        return try await client.request(endpoint, decode: CardDTO.self)
    }

    func cancelRequest(_ request: URLRequest?) {
        client.cancelRequest(request)
    }
}
