//
//  DeckDTO+Stub.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

@testable import SWDestinyTrades

extension DeckDTO {

    static func stub(emptyList: Bool = false, cards: [CardDTO] = []) -> DeckDTO {
        let deck = DeckDTO()
        deck.name = "Mock Deck"

        if !emptyList, cards.isEmpty {
            let list: List<CardDTO> = JSONHelper.loadJSON(withFile: "card-list")!
            deck.list.append(objectsIn: list)
        } else if !cards.isEmpty {
            deck.list.append(objectsIn: cards)
        } else {
            deck.list.append(objectsIn: [])
        }
        return deck
    }
}
