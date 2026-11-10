//
//  DeleteDeckEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 10/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct DeleteDeckEndpoint: EndpointProtocol {
    let remoteID: Int

    var path: String {
        "/api/deck/delete/\(remoteID)"
    }

    var method: HttpMethod {
        .delete
    }

    var needsToken: Bool {
        true
    }
}
