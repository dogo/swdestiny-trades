//
//  CardDTOMock.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 12/07/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Foundation
@testable import SWDestiny_Trades

enum CardDTOMock {

    static let mockInfo: [String: Any?] = ["sides": ["1RD", "2RD", "1F", "1Dc", "1R", "-"],
                                     "set_code": "AW",
                                     "set_name": "Awakenings",
                                     "type_code": "character",
                                     "type_name": "Character",
                                     "faction_code": "red",
                                     "faction_name": "Command",
                                     "affiliation_code": "villain",
                                     "affiliation_name": "Villain",
                                     "rarity_code": "L",
                                     "rarity_name": "Legendary",
                                     "position": 1,
                                     "code": "01001",
                                     "ttscardid": "1300",
                                     "name": "Captain Phasma",
                                     "subtitle": "Elite Trooper",
                                     "cost": nil,
                                     "health": 11,
                                     "points": "12/15",
                                     "text": "Your non-unique characters have the Guardian keyword.",
                                     "deck_limit": 1,
                                     "flavor": "Whatever you're planning, it won't work.",
                                     "illustrator": "Darren Tan",
                                     "is_unique": true,
                                     "has_die": true,
                                     "has_errata": false,
                                     "url": "http://swdestinydb.com/card/01001",
                                     "imagesrc": "http://swdestinydb.com/bundles/cards/en/01/01001.jpg",
                                     "label": "Captain Phasma - Elite Trooper",
                                     "cp": 1215]

    static func mockedCardDTO() -> Result<CardDTO> {
        let result: Result<CardDTO>
        let jsonData = try? JSONSerialization.data(withJSONObject: mockInfo, options: [])
        do {
            result = .success(try JSONDecoder().decode(CardDTO.self, from: jsonData!))
        } catch {
            result = .failure(error)
        }
        return result
    }

    static func mockedCardListDTO() -> Result<[CardDTO]> {

        let result: Result<[CardDTO]>
        let jsonData = try? JSONSerialization.data(withJSONObject: [mockInfo], options: [])
        do {
            result = .success(try JSONDecoder().decode([CardDTO].self, from: jsonData!))
        } catch {
            result = .failure(error)
        }
        return result
    }
}
