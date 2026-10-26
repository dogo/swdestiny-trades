//
//  AuthEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

enum AuthEndpoint {
    case authorize(clientID: String, state: String)
    case token(clientID: String, clientSecret: String, code: String)

    static let callbackScheme = "swdestinytrades"
    static let redirectURI = "\(callbackScheme)://oauth-callback"
}

extension AuthEndpoint: EndpointProtocol {
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
        case .authorize:
            return "/oauth/v2/auth"
        case .token:
            return "/oauth/v2/token"
        }
    }

    /// The query parameters to be used in the request.
    var queryParameters: QueryParameters? {
        switch self {
        case let .authorize(clientID, state):
            return [
                "client_id": clientID,
                "response_type": "code",
                "redirect_uri": Self.redirectURI,
                "state": state
            ]
        case .token:
            return nil
        }
    }

    /// The body parameters to be used in the request.
    var bodyParameters: BodyParameters? {
        switch self {
        case .authorize:
            return nil
        case let .token(clientID, clientSecret, code):
            return [
                "grant_type": "authorization_code",
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": code,
                "redirect_uri": Self.redirectURI
            ]
        }
    }

    /// The HTTP method used in the request.
    var method: HttpMethod {
        switch self {
        case .authorize:
            return .get
        case .token:
            return .post
        }
    }

    /// The headers to be used in the request.
    var headers: HttpHeaders? {
        switch self {
        case .authorize:
            return nil
        case .token:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }

    /// The components of a URL.
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme.toString()
        components.host = host
        components.path = path
        components.queryItems = queryParameters?.items.sorted { $0.name < $1.name }
        return components
    }

    /// The URLRequest with the given URL and httpMethod.
    var request: URLRequest {
        var request = URLRequest(with: urlComponents.url)
        request.httpMethod = method.toString()
        request.allHTTPHeaderFields = headers
        request.httpBody = bodyParameters?.formEncoded
        return request
    }
}
