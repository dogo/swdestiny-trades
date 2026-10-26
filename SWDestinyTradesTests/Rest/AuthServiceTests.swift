//
//  AuthServiceTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import Testing

@testable import SWDestinyTrades

@MainActor
final class AuthServiceTests {

    private var client: HttpClientMock!
    private var keychain: KeychainStoreMock!
    private var sut: AuthService!

    init() {
        client = HttpClientMock()
        client.fileName = "oauth-token"
        keychain = KeychainStoreMock()
        sut = AuthService(client: client, keychain: keychain, clientID: "client", clientSecret: "secret")
    }

    isolated deinit {
        sut = nil
        keychain = nil
        client = nil
    }

    private func callbackURL(state: String) -> URL {
        var components = URLComponents(string: AuthEndpoint.redirectURI)!
        components.queryItems = [URLQueryItem(name: "state", value: state), URLQueryItem(name: "code", value: "abc")]
        return components.url!
    }

    private func startLogin() throws -> String {
        let url = try sut.authorizationURL()
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        return try #require(items.first { $0.name == "state" }?.value)
    }

    @Test
    func authorizationURL_containsClientAndRedirect() throws {
        let url = try sut.authorizationURL()
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) })

        #expect(components.host == "db.swdrenewedhope.com")
        #expect(components.path == "/oauth/v2/auth")
        #expect(items["client_id"] == "client")
        #expect(items["response_type"] == "code")
        #expect(items["redirect_uri"] == "swdestinytrades://oauth-callback")
        #expect(items["state"] != nil)
    }

    @Test
    func authorizationURL_withoutCredentials_throwsNotConfigured() {
        let sut = AuthService(client: client, keychain: keychain, clientID: "", clientSecret: "")

        #expect(throws: AuthError.notConfigured) { try sut.authorizationURL() }
    }

    @Test
    func completeLogin_exchangesCodeAndStoresToken() async throws {
        let state = try startLogin()

        try await sut.completeLogin(callbackURL: callbackURL(state: state))

        let request = try #require(client.lastRequest)
        let body = String(decoding: try #require(request.httpBody), as: UTF8.self)
        #expect(request.url?.absoluteString == "https://db.swdrenewedhope.com/oauth/v2/token")
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/x-www-form-urlencoded")
        #expect(body == "client_id=client&client_secret=secret&code=abc&grant_type=authorization_code&redirect_uri=swdestinytrades://oauth-callback")
        #expect(sut.token == OAuthTokenDTO(accessToken: "access", refreshToken: "refresh", expiresIn: 3600))
    }

    @Test
    func completeLogin_withMismatchedState_throwsWithoutRequestingToken() async throws {
        _ = try startLogin()

        await #expect(throws: AuthError.invalidCallback) {
            try await self.sut.completeLogin(callbackURL: self.callbackURL(state: "forged"))
        }
        #expect(client.lastRequest == nil)
        #expect(sut.isLoggedIn == false)
    }

    @Test
    func completeLogin_withoutPendingLogin_throws() async {
        await #expect(throws: AuthError.invalidCallback) {
            try await self.sut.completeLogin(callbackURL: self.callbackURL(state: "anything"))
        }
    }

    @Test
    func completeLogin_whenTokenRequestFails_staysLoggedOut() async throws {
        client.error = true
        let state = try startLogin()

        await #expect(throws: AuthError.tokenRequestFailed) {
            try await self.sut.completeLogin(callbackURL: self.callbackURL(state: state))
        }
        #expect(sut.isLoggedIn == false)
    }

    @Test
    func completeLogin_whenKeychainWriteFails_throws() async throws {
        keychain.setSucceeds = false
        let state = try startLogin()

        await #expect(throws: AuthError.tokenRequestFailed) {
            try await self.sut.completeLogin(callbackURL: self.callbackURL(state: state))
        }
        #expect(sut.isLoggedIn == false)
    }

    @Test
    func logout_removesToken() async throws {
        let state = try startLogin()
        try await sut.completeLogin(callbackURL: callbackURL(state: state))

        sut.logout()

        #expect(sut.isLoggedIn == false)
        #expect(keychain.storage.isEmpty)
    }
}
