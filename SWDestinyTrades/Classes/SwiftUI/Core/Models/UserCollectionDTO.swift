//
//  UserCollectionDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 03/15/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

final class UserCollectionDTO: Storable, Identifiable {
    var id: String = UUID().uuidString
    var myCollection: [CardDTO] = []

    init() {}
}

extension UserCollectionDTO: Equatable {
    static func == (lhs: UserCollectionDTO, rhs: UserCollectionDTO) -> Bool {
        lhs.id == rhs.id
    }
}

extension UserCollectionDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
