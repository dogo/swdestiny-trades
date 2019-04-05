//
//  SWDestinyRoute.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 12/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Moya

enum SWDestinyRoute {
    case setList
    case cardList(setCode: String)
    case allCards
    case card(cardId: String)
}

extension SWDestinyRoute: TargetType {

    var baseURL: URL {
        return URL(string: "http://swdestinydb.com")! // swiftlint:disable:this force_unwrapping
    }

    var path: String {
        switch self {
        case .setList:
            return "/api/public/sets/"
        case .cardList(let setCode):
            return "/api/public/cards/\(setCode)"
        case .allCards:
            return "/api/public/cards/"
        case .card(let cardId):
            return "/api/public/card/\(cardId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .setList, .cardList, .allCards, .card:
            return .get
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var sampleData: Data {
        var json = ""
        switch self {
        case .allCards, .cardList:
            json = """
            [{
            \"sides\": [
            \"1RD\",
            \"2RD\",
            \"1F\",
            \"1Dc\",
            \"1R\",
            \"-\"
            ],
            \"set_code\": \"AW\",
            \"set_name\": \"Awakenings\",
            \"type_code\": \"character\",
            \"type_name\": \"Character\",
            \"faction_code\": \"red\",
            \"faction_name\": \"Command\",
            \"affiliation_code\": \"villain\",
            \"affiliation_name\": \"Villain\",
            \"rarity_code\": \"L\",
            \"rarity_name\": \"Legendary\",
            \"position\": 1,
            \"code\": \"01001\",
            \"ttscardid\": \"1300\",
            \"name\": \"Captain Phasma\",
            \"subtitle\": \"Elite Trooper\",
            \"cost\": null,
            \"health\": 11,
            \"points\": \"12/15\",
            \"text\": \"Your non-unique characters have the Guardian keyword.\",
            \"deck_limit\": 1,
            \"flavor\": \"Whatever you're planning, it won't work.\",
            \"illustrator\": \"Darren Tan\",
            \"is_unique\": true,
            \"has_die\": true,
            \"has_errata\": false,
            \"url\": \"https://swdestinydb.com/card/01001\",
            \"imagesrc\": \"https://swdestinydb.com/bundles/cards/en/01/01001.jpg\",
            \"label\": \"Captain Phasma - Elite Trooper\",
            \"cp\": 1215
            }]
            """
        case .card:
            json = """
            {
            \"sides\": [
            \"1RD\",
            \"2RD\",
            \"1F\",
            \"1Dc\",
            \"1R\",
            \"-\"
            ],
            \"set_code\": \"AW\",
            \"set_name\": \"Awakenings\",
            \"type_code\": \"character\",
            \"type_name\": \"Character\",
            \"faction_code\": \"red\",
            \"faction_name\": \"Command\",
            \"affiliation_code\": \"villain\",
            \"affiliation_name\": \"Villain\",
            \"rarity_code\": \"L\",
            \"rarity_name\": \"Legendary\",
            \"position\": 1,
            \"code\": \"01001\",
            \"ttscardid\": \"1300\",
            \"name\": \"Captain Phasma\",
            \"subtitle\": \"Elite Trooper\",
            \"cost\": null,
            \"health\": 11,
            \"points\": \"12/15\",
            \"text\": \"Your non-unique characters have the Guardian keyword.\",
            \"deck_limit\": 1,
            \"flavor\": \"Whatever you're planning, it won't work.\",
            \"illustrator\": \"Darren Tan\",
            \"is_unique\": true,
            \"has_die\": true,
            \"has_errata\": false,
            \"url\": \"https://swdestinydb.com/card/01001\",
            \"imagesrc\": \"https://swdestinydb.com/bundles/cards/en/01/01001.jpg\",
            \"label\": \"Captain Phasma - Elite Trooper\",
            \"cp\": 1215
            }
            """
        case .setList:
            json = """
            [{
            \"name\": \"Awakenings\",
            \"code\": \"AW\",
            \"position\": 1,
            \"available\": \"2016-12-01\",
            \"known\": 174,
            \"total\": 174,
            \"url\": \"https://swdestinydb.com/set/AW\"
            }]
            """
        }

        guard let data = json.data(using: .utf8) else {
            fatalError("Error sample data JSON")
        }
        return data
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
