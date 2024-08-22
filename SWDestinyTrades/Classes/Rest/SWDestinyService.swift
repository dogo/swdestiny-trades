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

    init(client: HttpClientProtocol = HttpClient()) {
        self.client = client
    }

    func search(query: String) async throws -> [CardDTO] {
        let endpoint: SWDestinyEndpoint = .search(query: query)
        let request = endpoint.request

        return try await client.request(request, decode: [CardDTO].self)
    }

    func retrieveSetList() async throws -> [SetDTO] {
        let endpoint: SWDestinyEndpoint = .setList
        let request = endpoint.request

        return try await client.request(request, decode: [SetDTO].self)
    }

    func retrieveSetCardList(setCode: String) async throws -> [CardDTO] {
        let endpoint: SWDestinyEndpoint = .cardList(setCode: setCode)
        let request = endpoint.request

        return try await client.request(request, decode: [CardDTO].self)
    }

    func retrieveAllCards(request: URLRequest) async throws -> [CardDTO] {
        return try await client.request(request, decode: [CardDTO].self)
    }

    func retrieveCard(cardId: String) async throws -> CardDTO {
        let endpoint: SWDestinyEndpoint = .card(cardId: cardId)
        let request = endpoint.request

        return try await client.request(request, decode: CardDTO.self)
    }

    func cancelRequest(_ request: URLRequest?) {
        client.cancelRequest(request)
    }
}
