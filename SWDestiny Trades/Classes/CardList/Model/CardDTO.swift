//
//  CardDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

class CardDTO: Object, Decodable, Storable {
    let dieFaces = List<StringObject>()
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var setCode: String = ""
    @objc dynamic var setName: String = ""
    @objc dynamic var typeCode: String = ""
    @objc dynamic var typeName: String = ""
    @objc dynamic var factionCode: String = ""
    @objc dynamic var factionName: String = ""
    @objc dynamic var affiliationCode: String = ""
    @objc dynamic var affiliationName: String = ""
    @objc dynamic var rarityCode: String = ""
    @objc dynamic var rarityName: String = ""
    @objc dynamic var position: Int = 0
    @objc dynamic var code: String = ""
    @objc dynamic var ttscardid: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var subtitle: String = ""
    @objc dynamic var cost: Int = 0
    @objc dynamic var health: Int = 0
    @objc dynamic var points: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var deckLimit: Int = 0
    @objc dynamic var flavor: String = ""
    @objc dynamic var illustrator: String = ""
    @objc dynamic var isUnique: Bool = false
    @objc dynamic var hasDie: Bool = false
    @objc dynamic var externalUrl: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var label: String = ""
    @objc dynamic var cp: Int = 0 // swiftlint:disable:this identifier_name
    // Non API properties
    @objc dynamic var quantity: Int = 1
    @objc dynamic var isElite: Bool = false

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
        case cp // swiftlint:disable:this identifier_name
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

        // Dogo : Realm Hack
        let sides: [String]? = try? container.decode([String].self, forKey: .dieFaces) // Maps to local variable

        dieFaces.removeAll()

        sides?.forEach { side in // Then fill sides to `List`
            let string = StringObject()
            string.value = side
            dieFaces.append(string)
        }
        // End hack
    }

    override class func primaryKey() -> String {
        return "id"
    }
}

class StringObject: Object, Storable {
    @objc dynamic var value: String?
}
