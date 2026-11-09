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
    private let invalidGrant = APIError.badRequest(Data(#"{"error":"invalid_grant"}"#.utf8))

    init() {
        client = HttpClientMock()
        client.stub = OAuthTokenDTO.stub()
        keychain = KeychainStoreMock()
        sut = AuthService(client: client, keychain: keychain, clientID: "client", clientSecret: "secret")
    }

    isolated deinit {
        sut = nil
        keychain = nil
        client = nil
    }

    private func callbackURL(state: String) -> URL {
        var components = URLComponents(string: AuthorizeEndpoint.redirectURI)!
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
        let body = try String(decoding: #require(request.httpBody), as: UTF8.self)
        #expect(request.url?.absoluteString == "https://db.swdrenewedhope.com/oauth/v2/token")
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/x-www-form-urlencoded")
        #expect(body == "client_id=client&client_secret=secret&code=abc&grant_type=authorization_code&redirect_uri=swdestinytrades://oauth-callback")
        #expect(keychain.oauthToken == .stub())
    }

    @Test
    func olderLogin_finishingAfterNewerLogin_keepsNewerSession() async throws {
        let olderState = try startLogin()
        let olderToken = OAuthTokenDTO.stub(accessToken: "older", refreshToken: "older-refresh")
        let newerToken = OAuthTokenDTO.stub(accessToken: "newer", refreshToken: "newer-refresh")
        client.stub = olderToken
        client.onRequest = { [weak self] in
            guard let self else { return }
            client.onRequest = nil
            client.stub = newerToken
            if let newerState = try? startLogin() {
                try? await sut.completeLogin(callbackURL: callbackURL(state: newerState))
            }
            client.stub = olderToken
        }

        await #expect(throws: CancellationError.self) {
            try await self.sut.completeLogin(callbackURL: self.callbackURL(state: olderState))
        }
        #expect(keychain.oauthToken == newerToken)
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
    func refreshToken_storesNewToken() async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        let refreshedToken = OAuthTokenDTO.stub(accessToken: "new", refreshToken: "new-refresh")
        client.stub = refreshedToken

        try await sut.refreshToken()

        let request = try #require(client.lastRequest)
        let body = try String(decoding: #require(request.httpBody), as: UTF8.self)
        #expect(keychain.oauthToken == refreshedToken)
        #expect(body == "client_id=client&client_secret=secret&grant_type=refresh_token&refresh_token=refresh")
    }

    @Test
    func refreshToken_rejected_clearsToken() async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        client.errorsToThrow = [invalidGrant]

        await #expect(throws: APIError.unauthorized) {
            try await self.sut.refreshToken()
        }
        #expect(sut.isLoggedIn == false)
    }

    @Test(arguments: [APIError.unauthorized, .badRequest(Data(#"{"error":"invalid_client"}"#.utf8))])
    func refreshToken_clientRejected_keepsToken(error: APIError) async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        client.errorsToThrow = [error]

        await #expect(throws: error) {
            try await self.sut.refreshToken()
        }
        #expect(sut.isLoggedIn)
    }

    @Test
    func refreshToken_serverError_keepsToken() async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        client.errorsToThrow = [APIError.serverError]

        await #expect(throws: APIError.serverError) {
            try await self.sut.refreshToken()
        }
        #expect(sut.isLoggedIn)
    }

    @Test
    func refreshToken_unsuccessfulResponse_keepsToken() async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        client.errorsToThrow = [APIError.responseUnsuccessful]

        await #expect(throws: APIError.responseUnsuccessful) {
            try await self.sut.refreshToken()
        }
        #expect(sut.isLoggedIn)
    }

    @Test
    func refreshToken_withoutStoredToken_throwsWithoutRequest() async {
        await #expect(throws: APIError.unauthorized) {
            try await self.sut.refreshToken()
        }
        #expect(client.lastRequest == nil)
    }

    @Test
    func logout_removesToken() async throws {
        let state = try startLogin()
        try await sut.completeLogin(callbackURL: callbackURL(state: state))

        sut.logout()

        #expect(sut.isLoggedIn == false)
        #expect(keychain.storage.isEmpty)
    }

    @Test
    func logout_duringRefresh_staysLoggedOut() async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        client.onRequest = { [weak self] in self?.sut.logout() }

        await #expect(throws: CancellationError.self) {
            try await self.sut.refreshToken()
        }
        #expect(sut.isLoggedIn == false)
    }

    @Test
    func failedRefresh_afterLogout_keepsNextSession() async throws {
        try keychain.set(JSONEncoder().encode(OAuthTokenDTO.stub()), for: OAuthTokenDTO.keychainKey)
        let nextSession = OAuthTokenDTO.stub(accessToken: "next", refreshToken: "next-refresh")
        let nextSessionData = try JSONEncoder().encode(nextSession)
        client.errorsToThrow = [invalidGrant]
        client.onRequest = { [weak self] in
            self?.sut.logout()
            self?.keychain.set(nextSessionData, for: OAuthTokenDTO.keychainKey)
        }

        await #expect(throws: CancellationError.self) {
            try await self.sut.refreshToken()
        }
        #expect(keychain.oauthToken == nextSession)
    }
}
