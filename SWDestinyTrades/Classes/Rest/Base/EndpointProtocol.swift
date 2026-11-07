//
//  EndpointProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 04/01/20.
//  Copyright © 2020 Diogo Autilio. All rights reserved.
//

import Foundation

typealias HttpHeaders = [String: String]
typealias QueryParameters = [String: String]
typealias BodyParameters = [String: Any]

protocol EndpointProtocol {
    var scheme: HttpScheme { get }
    var host: String { get }
    var path: String { get }
    var queryParameters: QueryParameters? { get }
    var bodyParameters: BodyParameters? { get }
    var method: HttpMethod { get }
    var headers: HttpHeaders? { get }
    var needsToken: Bool { get }
    var request: URLRequest { get }
}

extension EndpointProtocol {
    var scheme: HttpScheme {
        return .https
    }

    var host: String {
        return "db.swdrenewedhope.com"
    }

    var queryParameters: QueryParameters? {
        return nil
    }

    var bodyParameters: BodyParameters? {
        return nil
    }

    var method: HttpMethod {
        return .get
    }

    var headers: HttpHeaders? {
        return nil
    }

    var needsToken: Bool {
        return false
    }

    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme.toString()
        components.host = host
        components.path = path
        components.queryItems = queryParameters?.items.sorted { $0.name < $1.name }
        return components
    }

    var request: URLRequest {
        var request = URLRequest(with: urlComponents.url)
        request.httpMethod = method.toString()
        request.allHTTPHeaderFields = headers
        request.httpBody = bodyParameters?.formEncoded
        return request
    }
}
