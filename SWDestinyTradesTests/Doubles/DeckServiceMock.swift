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

    func retrieveDecks() async throws -> [DeckDTO] {
        decks
    }
}
