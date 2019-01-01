//
//  SWDestinyService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/4/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Moya

enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol SWDestinyService {
    @discardableResult
    func retrieveSetList(completion: @escaping (Result<[SetDTO]>) -> Void) -> Cancellable

    @discardableResult
    func retrieveSetCardList(setCode: String, completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable

    @discardableResult
    func retrieveAllCards(completion: @escaping (Result<[CardDTO]>) -> Void) -> Cancellable

    @discardableResult
    func retrieveCard(cardId: String, completion: @escaping (Result<CardDTO>) -> Void) -> Cancellable
}
