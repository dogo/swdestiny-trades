//
//  SearchEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct SearchEndpoint: EndpointProtocol {
    let query: String

    var path: String {
        "/api/find"
    }

    var queryParameters: QueryParameters? {
        ["q": query]
    }
}
