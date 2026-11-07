//
//  SWDestinyService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation

final class SWDestinyService: SWDestinyServiceProtocol {

    private let client: HttpClientProtocol

    init(client: HttpClientProtocol) {
        self.client = client
    }

    func search(query: String) async throws -> [CardDTO] {
        let endpoint = SearchEndpoint(query: query)

        return try await client.request(endpoint, decode: [CardDTO].self)
    }

    func retrieveSetList() async throws -> [SetDTO] {
        let endpoint = SetListEndpoint()

        return try await client.request(endpoint, decode: [SetDTO].self)
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
