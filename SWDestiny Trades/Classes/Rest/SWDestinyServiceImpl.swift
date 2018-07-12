//
//  SWDestinyServiceImpl.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/4/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

class SWDestinyServiceImpl: SWDestinyService {

    let api: SWDestinyService

    init(api: SWDestinyService = SWDestinyAPI()) {
        self.api = api
    }

    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) {
        self.api.retrieveSetList(completion: completion)
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) {
        self.api.retrieveSetCardList(setCode: setCode, completion: completion)
    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) {
        self.api.retrieveAllCards(completion: completion)
    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) {
        self.api.retrieveCard(cardId: cardId, completion: completion)
    }
}
