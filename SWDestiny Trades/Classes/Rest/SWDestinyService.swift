//
//  SWDestinyService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/4/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}

protocol SWDestinyService {

    func retrieveSetList(completion: @escaping (Result<[SetDTO]?, APIError>) -> Void)

    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]?, APIError>) -> Void)

    func retrieveAllCards(completion: @escaping (Result<[CardDTO]?, APIError>) -> Void)

    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO?, APIError>) -> Void)

    func cancelAllRequests()
}
