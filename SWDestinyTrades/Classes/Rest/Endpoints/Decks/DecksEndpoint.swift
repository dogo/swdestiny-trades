//
//  DecksEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct DecksEndpoint: EndpointProtocol {
    var path: String {
        "/api/decks"
    }

    var needsToken: Bool {
        true
    }
}
