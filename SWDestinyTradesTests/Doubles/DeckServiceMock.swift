//
//  DeckServiceMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class DeckServiceMock: DeckServiceProtocol {
    var decks: [DeckDTO] = []
    var error: Error?
    private(set) var savedRemoteIDs: [Int] = []

    func retrieveDecks() async throws -> [DeckDTO] {
        if let error {
            throw error
        }
        return decks
    }

    func saveDeck(_ deck: DeckDTO, remoteID: Int) async throws {
        if let error {
            throw error
        }
        savedRemoteIDs.append(remoteID)
    }
}
