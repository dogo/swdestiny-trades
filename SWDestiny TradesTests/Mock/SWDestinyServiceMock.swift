//
//  SWDestinyServiceMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//
@testable import SWDestiny_Trades

class SWDestinyServiceMock: SWDestinyService {

    var isCancelled = false

    func retrieveSetList(completion: @escaping (Result<[SetDTO]?, APIError>) -> Void) {
        let json: [SetDTO] = JSONHelper.loadJSON(withFile: "sets")!
        return completion(.success(json))
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]?, APIError>) -> Void) {
        let json: [CardDTO] = JSONHelper.loadJSON(withFile: "card-list")!
        return completion(.success(json))
    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]?, APIError>) -> Void) {
        let json: [CardDTO] = JSONHelper.loadJSON(withFile: "card-list")!
        return completion(.success(json))
    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO?, APIError>) -> Void) {
        let json: CardDTO = JSONHelper.loadJSON(withFile: "card")!
        return completion(.success(json))
    }

    func cancelAllRequests() {
        self.isCancelled = true
    }
}
