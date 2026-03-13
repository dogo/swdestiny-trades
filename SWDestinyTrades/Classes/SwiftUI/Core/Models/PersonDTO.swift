//
//  PersonDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 29/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation

class PersonDTO: Storable, Identifiable {
    var id: String = UUID().uuidString
    var name: String = ""
    var lastName: String = ""
    var lentMe: [CardDTO] = []
    var borrowed: [CardDTO] = []

    init() {}
}

extension PersonDTO: Equatable {
    static func == (lhs: PersonDTO, rhs: PersonDTO) -> Bool {
        lhs.id == rhs.id
    }
}

extension PersonDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
