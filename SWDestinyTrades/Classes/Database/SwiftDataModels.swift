//
//  SwiftDataModels.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 13/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import SwiftData

// MARK: - CardSD

@Model
final class CardSD {
    @Attribute(.unique) var id: String
    var code: String
    var name: String
    var subtitle: String
    var setCode: String
    var setName: String
    var typeCode: String
    var typeName: String
    var factionCode: String
    var factionName: String
    var affiliationCode: String
    var affiliationName: String
    var rarityCode: String
    var rarityName: String
    var position: Int
    var ttscardid: String
    var cost: Int
    var health: Int
    var points: String
    var text: String
    var deckLimit: Int
    var flavor: String
    var illustrator: String
    var isUnique: Bool
    var hasDie: Bool
    var externalUrl: String
    var imageUrl: String
    var label: String
    var cp: Int
    var quantity: Int
    var isElite: Bool
    var dieFaces: [String]

    // Inverse relationships
    var deck: DeckSD?
    var lender: PersonSD?
    var borrower: PersonSD?
    var userCollection: UserCollectionSD?

    init(
        id: String,
        code: String = "",
        name: String = "",
        subtitle: String = "",
        setCode: String = "",
        setName: String = "",
        typeCode: String = "",
        typeName: String = "",
        factionCode: String = "",
        factionName: String = "",
        affiliationCode: String = "",
        affiliationName: String = "",
        rarityCode: String = "",
        rarityName: String = "",
        position: Int = 0,
        ttscardid: String = "",
        cost: Int = 0,
        health: Int = 0,
        points: String = "",
        text: String = "",
        deckLimit: Int = 0,
        flavor: String = "",
        illustrator: String = "",
        isUnique: Bool = false,
        hasDie: Bool = false,
        externalUrl: String = "",
        imageUrl: String = "",
        label: String = "",
        cp: Int = 0,
        quantity: Int = 1,
        isElite: Bool = false,
        dieFaces: [String] = []
    ) {
        self.id = id
        self.code = code
        self.name = name
        self.subtitle = subtitle
        self.setCode = setCode
        self.setName = setName
        self.typeCode = typeCode
        self.typeName = typeName
        self.factionCode = factionCode
        self.factionName = factionName
        self.affiliationCode = affiliationCode
        self.affiliationName = affiliationName
        self.rarityCode = rarityCode
        self.rarityName = rarityName
        self.position = position
        self.ttscardid = ttscardid
        self.cost = cost
        self.health = health
        self.points = points
        self.text = text
        self.deckLimit = deckLimit
        self.flavor = flavor
        self.illustrator = illustrator
        self.isUnique = isUnique
        self.hasDie = hasDie
        self.externalUrl = externalUrl
        self.imageUrl = imageUrl
        self.label = label
        self.cp = cp
        self.quantity = quantity
        self.isElite = isElite
        self.dieFaces = dieFaces
    }
}

// MARK: - SetSD

@Model
final class SetSD {
    @Attribute(.unique) var code: String
    var id: String
    var name: String

    init(code: String, id: String = UUID().uuidString, name: String = "") {
        self.code = code
        self.id = id
        self.name = name
    }
}

// MARK: - DeckSD

@Model
final class DeckSD {
    @Attribute(.unique) var id: String
    var name: String
    @Relationship(deleteRule: .nullify, inverse: \CardSD.deck) var list: [CardSD]

    init(id: String, name: String = "", list: [CardSD] = []) {
        self.id = id
        self.name = name
        self.list = list
    }
}

// MARK: - PersonSD

@Model
final class PersonSD {
    @Attribute(.unique) var id: String
    var name: String
    var lastName: String
    @Relationship(deleteRule: .nullify, inverse: \CardSD.lender) var lentMe: [CardSD]
    @Relationship(deleteRule: .nullify, inverse: \CardSD.borrower) var borrowed: [CardSD]

    init(id: String, name: String = "", lastName: String = "", lentMe: [CardSD] = [], borrowed: [CardSD] = []) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.lentMe = lentMe
        self.borrowed = borrowed
    }
}

// MARK: - UserCollectionSD

@Model
final class UserCollectionSD {
    @Attribute(.unique) var id: String
    @Relationship(deleteRule: .nullify, inverse: \CardSD.userCollection) var myCollection: [CardSD]

    init(id: String, myCollection: [CardSD] = []) {
        self.id = id
        self.myCollection = myCollection
    }
}
