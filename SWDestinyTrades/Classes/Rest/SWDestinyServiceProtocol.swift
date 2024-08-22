//
//  SWDestinyServiceProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/4/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

protocol SWDestinyServiceProtocol {

    func search(query: String) async throws -> [CardDTO]

    func retrieveSetList() async throws -> [SetDTO]

    func retrieveSetCardList(setCode: String) async throws -> [CardDTO]

    func retrieveAllCards() async throws -> [CardDTO]

    func retrieveCard(cardId: String) async throws -> CardDTO

    func cancelRequest(_ request: URLRequest?)
}
