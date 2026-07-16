//
//  DeckListItem.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 16/07/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

struct DeckListItem: Identifiable, Equatable {
    let id: String
    let name: String
    let cardCount: Int

    init(deck: DeckDTO) {
        id = deck.id
        name = deck.name
        cardCount = deck.list.reduce(0) { $0 + $1.quantity }
    }
}
