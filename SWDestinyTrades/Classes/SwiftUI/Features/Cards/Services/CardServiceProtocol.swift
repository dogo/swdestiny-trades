//
//  CardServiceProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

protocol CardServiceProtocol {

    func retrieveSetCardList(setCode: String) async throws -> [CardDTO]

    func retrieveAllCards() async throws -> [CardDTO]

    func retrieveCard(cardId: String) async throws -> CardDTO

    func cancelRequest(_ request: URLRequest?)
}
