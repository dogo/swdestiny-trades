//
//  CardDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

class CardDTO: Object, Decodable, Storable, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var dieFaces = List<String>()
    @Persisted var setCode: String = ""
    @Persisted var setName: String = ""
    @Persisted var typeCode: String = ""
    @Persisted var typeName: String = ""
    @Persisted var factionCode: String = ""
    @Persisted var factionName: String = ""
    @Persisted var affiliationCode: String = ""
    @Persisted var affiliationName: String = ""
    @Persisted var rarityCode: String = ""
    @Persisted var rarityName: String = ""
    @Persisted var position: Int = 0
    @Persisted var code: String = ""
    @Persisted var ttscardid: String = ""
    @Persisted var name: String = ""
    @Persisted var subtitle: String = ""
    @Persisted var cost: Int = 0
    @Persisted var health: Int = 0
    @Persisted var points: String = ""
    @Persisted var text: String = ""
    @Persisted var deckLimit: Int = 0
    @Persisted var flavor: String = ""
    @Persisted var illustrator: String = ""
    @Persisted var isUnique: Bool = false
    @Persisted var hasDie: Bool = false
    @Persisted var externalUrl: String = ""
    @Persisted var imageUrl: String = ""
    @Persisted var label: String = ""
    @Persisted var cp: Int = 0
    // Non API properties
    @Persisted var quantity: Int = 1
    @Persisted var isElite: Bool = false

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

    required convenience init(from decoder: Decoder) throws {
        self.init()
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

        let faces: [String] = try container.decodeSafely(key: .dieFaces, defaultValue: [])
        dieFaces.append(objectsIn: faces)
    }
}
