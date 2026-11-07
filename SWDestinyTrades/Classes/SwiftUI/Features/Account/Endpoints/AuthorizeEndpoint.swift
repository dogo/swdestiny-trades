//
//  AuthorizeEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct AuthorizeEndpoint: EndpointProtocol {
    static let callbackScheme = "swdestinytrades"
    static let redirectURI = "\(callbackScheme)://oauth-callback"

    let clientID: String
    let state: String

    var path: String {
        "/oauth/v2/auth"
    }

    var queryParameters: QueryParameters? {
        [
            "client_id": clientID,
            "response_type": "code",
            "redirect_uri": Self.redirectURI,
            "state": state
        ]
    }
}
