//
//  DeckServiceProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

protocol DeckServiceProtocol {

    func retrieveDecks() async throws -> [DeckDTO]
    func saveDeck(_ deck: DeckDTO, remoteID: Int) async throws
}
