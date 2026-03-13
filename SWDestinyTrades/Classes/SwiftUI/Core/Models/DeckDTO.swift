//
//  DeckDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 18/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

class DeckDTO: Storable, Identifiable {
    var id: String = UUID().uuidString
    var name: String = ""
    var list: [CardDTO] = []

    init() {}
}

extension DeckDTO: Equatable {
    static func == (lhs: DeckDTO, rhs: DeckDTO) -> Bool {
        lhs.id == rhs.id
    }
}

extension DeckDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
