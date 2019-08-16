//
//  SWDestinyRoute.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 12/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

protocol Endpoint {

    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
}

enum SWDestinyRoute {
    case setList
    case cardList(setCode: String)
    case allCards
    case card(cardId: String)
}

extension SWDestinyRoute: Endpoint {

    /// The target's base `URL`.
    var baseURL: String {
        return "https://swdestinydb.com"
    }

    /// The path to be appended to `baseURL` to form the full `URL`.
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
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    /// The components of a URL.
    var urlComponents: URLComponents {
        var components = URLComponents(string: baseURL)! // swiftlint:disable:this force_unwrapping
        components.path = path
        return components
    }

    /// The URLRequest with the given URL and httpMethod.
    var request: URLRequest {
        var request = URLRequest(url: urlComponents.url!) // swiftlint:disable:this force_unwrapping
        request.httpMethod = method.toString()
        request.allHTTPHeaderFields = headers
        return request
    }
}
