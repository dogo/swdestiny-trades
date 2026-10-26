//
//  AuthError.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

enum AuthError: LocalizedError, Equatable {
    case notConfigured
    case invalidCallback
    case tokenRequestFailed

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return L10n.loginNotConfigured
        case .invalidCallback, .tokenRequestFailed:
            return L10n.loginFailed
        }
    }
}
