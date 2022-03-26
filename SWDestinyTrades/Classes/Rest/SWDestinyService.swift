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

    func search(query: String, completion: @escaping (Result<[CardDTO], APIError>) -> Void) {
        let endpoint: SWDestinyEndpoint = .search(query: query)
        let request = endpoint.request

        client.request(request, completion: completion)
    }

    func retrieveSetList(completion: @escaping (Result<[SetDTO], APIError>) -> Void) {
        let endpoint: SWDestinyEndpoint = .setList
        let request = endpoint.request

        client.request(request, completion: completion)
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO], APIError>) -> Void) {
        let endpoint: SWDestinyEndpoint = .cardList(setCode: setCode)
        let request = endpoint.request

        client.request(request, completion: completion)
    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO], APIError>) -> Void) {
        let endpoint: SWDestinyEndpoint = .allCards
        let request = endpoint.request

        client.request(request, completion: completion)
    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO, APIError>) -> Void) {
        let endpoint: SWDestinyEndpoint = .card(cardId: cardId)
        let request = endpoint.request

        client.request(request, completion: completion)
    }

    func cancelAllRequests() {
        client.cancelAllRequests()
    }
}
