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

    dynamic var sides: String = ""
    dynamic var setCode: String = ""
    dynamic var setName: String = ""
    dynamic var typeCode: String = ""
    dynamic var typeName: String = ""
    dynamic var factionCode: String = ""
    dynamic var factionName: String = ""
    dynamic var affiliationCode: String = ""
    dynamic var affiliationName: String = ""
    dynamic var rarityCode: String = ""
    dynamic var rarityName: String = ""
    dynamic var position: Int = 0
    dynamic var code: String = ""
    dynamic var ttscardid: String = ""
    dynamic var name: String = ""
    dynamic var subtitle: String = ""
    dynamic var cost: Float = 0.0
    dynamic var health: Int = 0
    dynamic var points: String = ""
    dynamic var text: String = ""
    dynamic var deckLimit: Int = 0
    dynamic var flavor: String = ""
    dynamic var illustrator: String = ""
    dynamic var isUnique: Bool = false
    dynamic var hasDie: Bool = false
    dynamic var externalUrl: String = ""
    dynamic var imageUrl: String = ""
    dynamic var label: String = ""
    dynamic var cp: Int = 0

    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }

    func mapping(map: Map) {
        sides <- map["sides"]
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
}
