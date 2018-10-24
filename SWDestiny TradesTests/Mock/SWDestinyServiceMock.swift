//
//  SWDestinyServiceMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//
import Moya

@testable import SWDestiny_Trades

class RequestMock: Cancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}

class SWDestinyServiceMock: SWDestinyService {
    
    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) -> Cancellable {
        return RequestMock() //completion(SetDTOMock.mockedSetDTO())
    }
    
    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return RequestMock()//completion(CardDTOMock.mockedCardListDTO())
    }
    
    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable {
        return RequestMock()//completion(CardDTOMock.mockedCardListDTO())
    }
    
    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) -> Cancellable {
        return RequestMock()//completion(CardDTOMock.mockedCardDTO())
    }
}
