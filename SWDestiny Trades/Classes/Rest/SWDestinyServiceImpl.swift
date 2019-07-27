//
//  SWDestinyServiceImpl.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/4/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Moya

final class SWDestinyServiceImpl: SWDestinyService {

    let api: SWDestinyService

    init(api: SWDestinyService = SWDestinyAPI()) {
        self.api = api
    }

    @discardableResult
    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) -> Cancellable {
        return self.api.retrieveSetList(completion: completion)
    }

    @discardableResult
    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return self.api.retrieveSetCardList(setCode: setCode, completion: completion)
    }

    @discardableResult
    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return self.api.retrieveAllCards(completion: completion)
    }

    @discardableResult
    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) -> Cancellable {
        return self.api.retrieveCard(cardId: cardId, completion: completion)
    }
}
