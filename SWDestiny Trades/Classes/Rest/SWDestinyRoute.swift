//
//  SWDestinyRoute.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 12/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum SWDestinyRoute {
    case setList
    case cardList(setCode: String)
    case allCards
    case card(cardId: String)
}

extension SWDestinyRoute: EndpointProtocol {

    /// The scheme subcomponent of the `URL`.
    var scheme: HttpScheme {
        return .https
    }

    /// The target's host `URL`.
    var host: String {
        return "swdestinydb.com"
    }

    /// The path to be appended to `host` to form the full `URL`.
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

    /// The HTTP method used in the request.
    var method: HttpMethod {
        switch self {
        case .setList, .cardList, .allCards, .card:
            return .get
        }
    }

    /// The headers to be used in the request.
    var headers: HttpHeaders? {
        return ["Content-type": "application/json"]
    }

    /// The components of a URL.
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme.toString()
        components.host = host
        components.path = path
        return components
    }

    /// The URLRequest with the given URL and httpMethod.
    var request: URLRequest {
        var request = URLRequest(with: urlComponents.url)
        request.httpMethod = method.toString()
        request.allHTTPHeaderFields = headers
        return request
    }
}
