//
//  OAuthTokenDTO+Stub.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 07/11/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

extension OAuthTokenDTO {

    static func stub(accessToken: String = "access",
                     refreshToken: String = "refresh",
                     expiresIn: Int = 3600) -> OAuthTokenDTO {
        return OAuthTokenDTO(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn)
    }
}
