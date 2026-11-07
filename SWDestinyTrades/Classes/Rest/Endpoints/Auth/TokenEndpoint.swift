//
//  TokenEndpoint.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct TokenEndpoint: EndpointProtocol {
    let clientID: String
    let clientSecret: String
    let code: String

    var path: String {
        "/oauth/v2/token"
    }

    var method: HttpMethod {
        .post
    }

    var headers: HttpHeaders? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }

    var bodyParameters: BodyParameters? {
        [
            "grant_type": "authorization_code",
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": code,
            "redirect_uri": AuthorizeEndpoint.redirectURI
        ]
    }
}
