//
//  HttpMethod.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/08/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

/// HTTP method definitions.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
enum HttpMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"

    func toString() -> String {
        return self.rawValue
    }
}
