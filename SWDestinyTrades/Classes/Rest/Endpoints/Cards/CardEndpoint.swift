//
//  CardEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct CardEndpoint: EndpointProtocol {
    let cardId: String

    var path: String {
        "/api/card/\(cardId)"
    }
}
