//
//  RemoteDeckDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

nonisolated struct RemoteDeckDTO: Decodable {
    nonisolated struct Slot: Decodable {
        let quantity: Int
        let dice: Int
    }

    let id: Int
    let name: String
    let slots: [String: Slot]

    var deck: DeckDTO {
        let deck = DeckDTO()
        deck.id = "arh-\(id)"
        deck.name = name
        deck.list = slots.sorted { $0.key < $1.key }.map { code, slot in
            let card = CardDTO()
            card.id = code
            card.code = code
            card.quantity = slot.quantity
            card.isElite = slot.dice > slot.quantity
            return card
        }
        return deck
    }
}
