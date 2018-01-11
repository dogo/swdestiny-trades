//
//  SWDestinyAPI.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 12/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation
import Moya

enum SWDestinyAPI {
    case setList()
    case cardList(setCode: String)
    case allCards()
    case card(cardId: String)
}

extension SWDestinyAPI: TargetType {

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
        switch self {
        default:
            return Data()
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
