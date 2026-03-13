//
//  CardDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation

class CardDTO: Decodable, Storable, Identifiable {
    var id: String = UUID().uuidString
    var dieFaces: [String] = []
    var setCode: String = ""
    var setName: String = ""
    var typeCode: String = ""
    var typeName: String = ""
    var factionCode: String = ""
    var factionName: String = ""
    var affiliationCode: String = ""
    var affiliationName: String = ""
    var rarityCode: String = ""
    var rarityName: String = ""
    var position: Int = 0
    var code: String = ""
    var ttscardid: String = ""
    var name: String = ""
    var subtitle: String = ""
    var cost: Int = 0
    var health: Int = 0
    var points: String = ""
    var text: String = ""
    var deckLimit: Int = 0
    var flavor: String = ""
    var illustrator: String = ""
    var isUnique: Bool = false
    var hasDie: Bool = false
    var externalUrl: String = ""
    var imageUrl: String = ""
    var label: String = ""
    var cp: Int = 0
    // Non API properties
    var quantity: Int = 1
    var isElite: Bool = false

    init() {}

    init(copying other: CardDTO) {
        dieFaces = other.dieFaces
        setCode = other.setCode
        setName = other.setName
        typeCode = other.typeCode
        typeName = other.typeName
        factionCode = other.factionCode
        factionName = other.factionName
        affiliationCode = other.affiliationCode
        affiliationName = other.affiliationName
        rarityCode = other.rarityCode
        rarityName = other.rarityName
        position = other.position
        code = other.code
        ttscardid = other.ttscardid
        name = other.name
        subtitle = other.subtitle
        cost = other.cost
        health = other.health
        points = other.points
        text = other.text
        deckLimit = other.deckLimit
        flavor = other.flavor
        illustrator = other.illustrator
        isUnique = other.isUnique
        hasDie = other.hasDie
        externalUrl = other.externalUrl
        imageUrl = other.imageUrl
        label = other.label
        cp = other.cp
        quantity = other.quantity
        isElite = other.isElite
    }

    enum CodingKeys: String, CodingKey {
        case dieFaces = "sides"
        case setCode = "set_code"
        case setName = "set_name"
        case typeCode = "type_code"
        case typeName = "type_name"
        case factionCode = "faction_code"
        case factionName = "faction_name"
        case affiliationCode = "affiliation_code"
        case affiliationName = "affiliation_name"
        case rarityCode = "rarity_code"
        case rarityName = "rarity_name"
        case position
        case code
        case ttscardid
        case name
        case subtitle
        case cost
        case health
        case points
        case text
        case deckLimit = "deck_limit"
        case flavor
        case illustrator
        case isUnique = "is_unique"
        case hasDie = "has_die"
        case externalUrl = "url"
        case imageUrl = "imagesrc"
        case label
        case cp
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        setCode = try container.decode(String.self, forKey: .setCode)
        setName = try container.decode(String.self, forKey: .setName)
        typeCode = try container.decode(String.self, forKey: .typeCode)
        typeName = try container.decode(String.self, forKey: .typeName)
        factionCode = try container.decode(String.self, forKey: .factionCode)
        factionName = try container.decode(String.self, forKey: .factionName)
        affiliationCode = try container.decode(String.self, forKey: .affiliationCode)
        affiliationName = try container.decode(String.self, forKey: .affiliationName)
        rarityCode = try container.decode(String.self, forKey: .rarityCode)
        rarityName = try container.decode(String.self, forKey: .rarityName)
        position = try container.decode(Int.self, forKey: .position)
        code = try container.decode(String.self, forKey: .code)
        ttscardid = try container.decodeSafely(key: .ttscardid, defaultValue: "")
        name = try container.decode(String.self, forKey: .name)
        subtitle = try container.decodeSafely(key: .subtitle, defaultValue: "")
        cost = try container.decodeSafely(key: .cost, defaultValue: 0)
        health = try container.decodeSafely(key: .health, defaultValue: 0)
        points = try container.decodeSafely(key: .points, defaultValue: "")
        text = try container.decodeSafely(key: .text, defaultValue: "")
        deckLimit = try container.decode(Int.self, forKey: .deckLimit)
        flavor = try container.decodeSafely(key: .flavor, defaultValue: "")
        illustrator = try container.decodeSafely(key: .illustrator, defaultValue: "")
        isUnique = try container.decode(Bool.self, forKey: .isUnique)
        hasDie = try container.decode(Bool.self, forKey: .hasDie)
        externalUrl = try container.decode(String.self, forKey: .externalUrl)
        imageUrl = try container.decodeSafely(key: .imageUrl, defaultValue: "")
        label = try container.decode(String.self, forKey: .label)
        cp = try container.decode(Int.self, forKey: .cp)
        dieFaces = try container.decodeSafely(key: .dieFaces, defaultValue: [])
    }
}

extension CardDTO: Equatable {
    static func == (lhs: CardDTO, rhs: CardDTO) -> Bool {
        lhs.id == rhs.id
    }
}

extension CardDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
