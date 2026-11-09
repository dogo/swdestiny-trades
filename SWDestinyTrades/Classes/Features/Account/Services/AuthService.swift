//
//  AuthService.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/10/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

final class AuthService: AuthServiceProtocol {

    private let client: HttpClientProtocol
    private let keychain: KeychainStoreProtocol
    private let clientID: String
    private let clientSecret: String
    private var pendingState: String?
    private var refreshTask: Task<Void, Error>?

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
        keychain.oauthToken != nil
    }

    func authorizationURL() throws -> URL {
        guard !clientID.isEmpty, !clientSecret.isEmpty else {
            throw AuthError.notConfigured
        }
        let state = UUID().uuidString
        let endpoint = AuthorizeEndpoint(clientID: clientID, state: state)
        guard let url = endpoint.urlComponents.url else {
            throw AuthError.notConfigured
        }
        pendingState = state
        return url
    }

    func completeLogin(callbackURL: URL) async throws {
        let items = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems ?? []
        let state = items.first { $0.name == "state" }?.value
        defer {
            if self.pendingState == state {
                self.pendingState = nil
            }
        }
        guard let pendingState, state == pendingState,
              let code = items.first(where: { $0.name == "code" })?.value else {
            throw AuthError.invalidCallback
        }

        let endpoint = TokenEndpoint(clientID: clientID, clientSecret: clientSecret, code: code)
        let token: OAuthTokenDTO
        do {
            token = try await client.request(endpoint, decode: OAuthTokenDTO.self)
        } catch {
            throw AuthError.tokenRequestFailed
        }

        guard self.pendingState == state else {
            throw CancellationError()
        }

        guard try keychain.set(JSONEncoder().encode(token), for: OAuthTokenDTO.keychainKey) else {
            throw AuthError.tokenRequestFailed
        }
    }

    func refreshToken() async throws {
        if let refreshTask {
            return try await refreshTask.value
        }

        guard let refreshToken = keychain.oauthToken?.refreshToken else {
            throw APIError.unauthorized
        }

        let endpoint = RefreshTokenEndpoint(clientID: clientID, clientSecret: clientSecret, refreshToken: refreshToken)
        let task = Task {
            do {
                let token = try await client.request(endpoint, decode: OAuthTokenDTO.self)
                try Task.checkCancellation()
                try keychain.set(JSONEncoder().encode(token), for: OAuthTokenDTO.keychainKey)
            } catch let APIError.badRequest(body) where isInvalidGrant(body) {
                try Task.checkCancellation()
                keychain.delete(OAuthTokenDTO.keychainKey)
                throw APIError.unauthorized
            }
        }
        refreshTask = task
        defer { refreshTask = nil }

        try await task.value
    }

    func logout() {
        refreshTask?.cancel()
        keychain.delete(OAuthTokenDTO.keychainKey)
    }

    private func isInvalidGrant(_ body: Data) -> Bool {
        (try? JSONDecoder().decode(OAuthErrorDTO.self, from: body))?.error == "invalid_grant"
    }
}

nonisolated struct OAuthErrorDTO: Decodable {
    let error: String
}
