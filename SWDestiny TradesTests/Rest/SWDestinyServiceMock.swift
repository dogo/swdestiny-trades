//
//  SWDestinyServiceMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

@testable import SWDestiny_Trades

class SWDestinyServiceMock: SWDestinyService {

    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) {
        completion(SetDTOMock.mockedSetDTO())
    }

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) {

    }

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) {

    }

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) {

    }
}
