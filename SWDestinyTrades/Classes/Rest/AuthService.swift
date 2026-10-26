//
//  AuthService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

final class AuthService: AuthServiceProtocol {

    private static let tokenKey = "oauth-token"

    private let client: HttpClientProtocol
    private let keychain: KeychainStoreProtocol
    private let clientID: String
    private let clientSecret: String
    private var pendingState: String?

    init(client: HttpClientProtocol,
         keychain: KeychainStoreProtocol = KeychainStore(service: Bundle.main.appBundleIdentifier),
         clientID: String = Bundle.main.arhClientID,
         clientSecret: String = Bundle.main.arhClientSecret) {
        self.client = client
        self.keychain = keychain
        self.clientID = clientID
        self.clientSecret = clientSecret
    }

    var isLoggedIn: Bool {
        token != nil
    }

    var token: OAuthTokenDTO? {
        keychain.data(for: Self.tokenKey).flatMap { try? JSONDecoder().decode(OAuthTokenDTO.self, from: $0) }
    }

    func authorizationURL() throws -> URL {
        guard !clientID.isEmpty, !clientSecret.isEmpty else {
            throw AuthError.notConfigured
        }
        let state = UUID().uuidString
        let endpoint: AuthEndpoint = .authorize(clientID: clientID, state: state)
        guard let url = endpoint.urlComponents.url else {
            throw AuthError.notConfigured
        }
        pendingState = state
        return url
    }

    func completeLogin(callbackURL: URL) async throws {
        let items = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems ?? []
        let state = items.first { $0.name == "state" }?.value
        defer { pendingState = nil }
        guard let pendingState, state == pendingState,
              let code = items.first(where: { $0.name == "code" })?.value else {
            throw AuthError.invalidCallback
        }

        let endpoint: AuthEndpoint = .token(clientID: clientID, clientSecret: clientSecret, code: code)
        let token: OAuthTokenDTO
        do {
            token = try await client.request(endpoint.request, decode: OAuthTokenDTO.self)
        } catch {
            throw AuthError.tokenRequestFailed
        }

        guard try keychain.set(JSONEncoder().encode(token), for: Self.tokenKey) else {
            throw AuthError.tokenRequestFailed
        }
    }

    func logout() {
        keychain.delete(Self.tokenKey)
    }
}
