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
        return completion(SetDTOMock.mockedSetDTO())
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]?, APIError>) -> Void) {
        return completion(CardDTOMock.mockedCardListDTO())
    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]?, APIError>) -> Void) {
        return completion(CardDTOMock.mockedCardListDTO())
    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO?, APIError>) -> Void) {
        return completion(CardDTOMock.mockedCardDTO())
    }

    func cancelAllRequests() {
        self.isCancelled = true
    }
}
