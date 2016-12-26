//
//  CardDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import ObjectMapper

class CardDTO: Mappable {

    var sides: String = ""
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
    var cost: Float = 0.0
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
    
    required init?(map: Map) {
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
