//
//  CardDTO+Stub.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension CardDTO {

    convenience init(setCode: String,
                     setName: String,
                     typeCode: String,
                     typeName: String,
                     factionCode: String,
                     factionName: String,
                     affiliationCode: String,
                     affiliationName: String,
                     rarityCode: String,
                     rarityName: String,
                     position: Int,
                     code: String,
                     ttscardid: String,
                     name: String,
                     subtitle: String,
                     cost: Int,
                     health: Int,
                     points: String,
                     text: String,
                     deckLimit: Int,
                     flavor: String,
                     illustrator: String,
                     isUnique: Bool,
                     hasDie: Bool,
                     externalUrl: String,
                     imageUrl: String,
                     label: String,
                     cp: Int, // swiftlint:disable:this identifier_name
                     quantity: Int,
                     isElite: Bool) {
        self.init()
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
        self.code = code
        self.ttscardid = ttscardid
        self.name = name
        self.subtitle = subtitle
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
    }

    static func stub(setCode: String = "AW",
                     setName: String = "Awakenings",
                     typeCode: String = "character",
                     typeName: String = "Character",
                     factionCode: String = "red",
                     factionName: String = "Command",
                     affiliationCode: String = "villain",
                     affiliationName: String = "Villain",
                     rarityCode: String = "L",
                     rarityName: String = "Legendary",
                     position: Int = 1,
                     code: String = "01001",
                     ttscardid: String = "1300",
                     name: String = "Captain Phasma",
                     subtitle: String = "Elite Trooper",
                     cost: Int = 0,
                     health: Int = 11,
                     points: String = "12/15",
                     text: String = "Your non-unique characters have the Guardian keyword.",
                     deckLimit: Int = 1,
                     flavor: String = "Whatever you're planning, it won't work.",
                     illustrator: String = "Darren Tan",
                     isUnique: Bool = true,
                     hasDie: Bool = true,
                     externalUrl: String = "https://swdestinydb.com/card/01001",
                     imageUrl: String = "https://swdestinydb.com/bundles/cards/en/01/01001.jpg",
                     label: String = "Captain Phasma - Elite Trooper",
                     cp: Int = 1215, // swiftlint:disable:this identifier_name
                     quantity: Int = 1,
                     isElite: Bool = false) -> CardDTO {
        return CardDTO(setCode: setCode,
                       setName: setName,
                       typeCode: typeCode,
                       typeName: typeName,
                       factionCode: factionCode,
                       factionName: factionName,
                       affiliationCode: affiliationCode,
                       affiliationName: affiliationName,
                       rarityCode: rarityCode,
                       rarityName: rarityName,
                       position: position,
                       code: code,
                       ttscardid: ttscardid,
                       name: name,
                       subtitle: subtitle,
                       cost: cost,
                       health: health,
                       points: points,
                       text: text,
                       deckLimit: deckLimit,
                       flavor: flavor,
                       illustrator: illustrator,
                       isUnique: isUnique,
                       hasDie: hasDie,
                       externalUrl: externalUrl,
                       imageUrl: imageUrl,
                       label: label,
                       cp: cp,
                       quantity: quantity,
                       isElite: isElite)
    }
}
