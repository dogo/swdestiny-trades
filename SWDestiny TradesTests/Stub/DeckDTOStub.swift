//
//  DeckDTOStub.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 20/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift
@testable import SWDestiny_Trades

extension DeckDTO {
    static func stub(emptyList: Bool = false) -> DeckDTO {
        let deck = DeckDTO()
        deck.name = "Mock Deck"
        if !emptyList {
            let list: List<CardDTO> = JSONHelper.loadJSON(withFile: "card-list")!
            deck.list.append(objectsIn: list)
        } else {
            deck.list.append(objectsIn: [])
        }

        return deck
    }
}
