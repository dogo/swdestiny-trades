//
//  SWDestinyAPI.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation

final class SWDestinyAPI: APIClient, SWDestinyService {

    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func retrieveSetList(completion: @escaping (Result<[SetDTO], APIError>) -> Void) {

        let endpoint: SWDestinyEndpoint = .setList
        let request = endpoint.request

        self.request(request, decode: { json -> [SetDTO]? in
            guard let result = json as? [SetDTO] else { return nil }
            return result
        }, completion: completion)
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO], APIError>) -> Void) {

        let endpoint: SWDestinyEndpoint = .cardList(setCode: setCode)
        let request = endpoint.request

        self.request(request, decode: { json -> [CardDTO]? in
            guard let result = json as? [CardDTO] else { return nil }
            return result
        }, completion: completion)
    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO], APIError>) -> Void) {

        let endpoint: SWDestinyEndpoint = .allCards
        let request = endpoint.request

        self.request(request, decode: { json -> [CardDTO]? in
            guard let result = json as? [CardDTO] else { return nil }
            return result
        }, completion: completion)
    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO, APIError>) -> Void) {

        let endpoint: SWDestinyEndpoint = .card(cardId: cardId)
        let request = endpoint.request

        self.request(request, decode: { json -> CardDTO? in
            guard let result = json as? CardDTO else { return nil }
            return result
        }, completion: completion)
    }

    func cancelAllRequests() {
        self.cancel()
    }
}
