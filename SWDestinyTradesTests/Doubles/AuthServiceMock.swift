//
//  AuthServiceMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class AuthServiceMock: AuthServiceProtocol {
    var isLoggedIn = false
    var authorizationURLError: Error?
    var completeLoginError: Error?
    private(set) var receivedCallbackURL: URL?
    private(set) var logoutCallCount = 0

    func authorizationURL() throws -> URL {
        if let authorizationURLError { throw authorizationURLError }
        return URL(string: "https://example.com/oauth/v2/auth")!
    }

    func completeLogin(callbackURL: URL) async throws {
        receivedCallbackURL = callbackURL
        if let completeLoginError { throw completeLoginError }
        isLoggedIn = true
    }

    func logout() {
        logoutCallCount += 1
        isLoggedIn = false
    }
}
