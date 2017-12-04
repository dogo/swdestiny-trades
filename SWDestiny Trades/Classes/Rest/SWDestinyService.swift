//
//  SWDestinyService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/4/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol SWDestinyService {
    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void)
    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void)
    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void)
    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void)
}
