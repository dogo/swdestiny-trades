//
//  CardDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class CardDTO: Object, Mappable {

    let dieFaces = List<StringObject>()
    @objc dynamic var id = NSUUID().uuidString // swiftlint:disable:this identifier_name
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
    @objc dynamic var quantity: Int = 1

    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }

    func mapping(map: Map) {
        // Dogo : Realm Hack
        var sides: [String]? = nil
        sides <- map["sides"] // Maps to local variable

        dieFaces.removeAll()

        sides?.forEach { side in // Then fill sides to `List`
            let string = StringObject()
            string.value = side
            dieFaces.append(string)
        }
        // End hack

        setCode <- map["set_code"]
        setName <- map["set_name"]
        typeCode <- map["type_code"]
        typeName <- map["type_name"]
        factionCode <- map["faction_code"]
        factionName <- map["faction_name"]
        affiliationCode <- map["affiliation_code"]
        affiliationName <- map["affiliation_name"]
        rarityCode <- map["rarity_code"]
        rarityName <- map["rarity_name"]
        position <- map["position"]
        code <- map["code"]
        ttscardid <- map["ttscardid"]
        name <- map["name"]
        subtitle <- map["subtitle"]
        cost <- map["cost"]
        health <- map["health"]
        points <- map["points"]
        text <- map["text"]
        deckLimit <- map["deck_limit"]
        flavor <- map["flavor"]
        illustrator <- map["illustrator"]
        isUnique <- map["is_unique"]
        hasDie <- map["has_die"]
        externalUrl <- map["url"]
        imageUrl <- map["imagesrc"]
        cp <- map["cp"]
    }

    override class func primaryKey() -> String {
        return "id"
    }
}

class StringObject: Object {
    @objc dynamic var value: String?
}
