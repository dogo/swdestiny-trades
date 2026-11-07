//
//  DeckEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

enum DeckEndpoint {
    case decks
}

extension DeckEndpoint: EndpointProtocol {
    /// The scheme subcomponent of the `URL`.
    var scheme: HttpScheme {
        return .https
    }

    /// The target's host `URL`.
    var host: String {
        return "db.swdrenewedhope.com"
    }

    /// The path to be appended to `host` to form the full `URL`.
    var path: String {
        switch self {
        case .decks:
            return "/api/decks"
        }
    }

    /// The query parameters to be used in the request.
    var queryParameters: QueryParameters? {
        return nil
    }

    /// The body parameters to be used in the request.
    var bodyParameters: BodyParameters? {
        return nil
    }

    /// The HTTP method used in the request.
    var method: HttpMethod {
        switch self {
        case .decks:
            return .get
        }
    }

    /// The headers to be used in the request.
    var headers: HttpHeaders? {
        return nil
    }

    /// Whether the request carries the user's access token.
    var needsToken: Bool {
        return true
    }

    /// The components of a URL.
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme.toString()
        components.host = host
        components.path = path
        components.queryItems = queryParameters?.items
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
