//
//  HttpClient.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/08/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

final class HttpClient: HttpClientProtocol {
    private let session: URLSession
    private let keychain: KeychainStoreProtocol
    private let clientID: String
    private let clientSecret: String
    private var activeTasks: [URLRequest: Task<(Data, URLResponse), Error>] = [:]
    private var refreshTask: Task<OAuthTokenDTO, Error>?

    init(session: URLSession = .shared,
         keychain: KeychainStoreProtocol = KeychainStore(service: Bundle.main.appBundleIdentifier),
         clientID: String = Bundle.main.arhClientID,
         clientSecret: String = Bundle.main.arhClientSecret) {
        self.session = session
        self.keychain = keychain
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
}

extension HttpClient {

    var logger: NetworkingLogger {
        #if DEBUG
            return NetworkingLogger(level: .debug)
        #else
            return NetworkingLogger(level: .none)
        #endif
    }

    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {

        logger.log(request: request)

        let requestDate = Date()

        let session = session
        let task = Task { try await session.data(for: request) }
        activeTasks[request] = task

        defer {
            activeTasks[request] = nil
        }

        do {
            let (data, response) = try await withTaskCancellationHandler {
                try await task.value
            } onCancel: {
                task.cancel()
            }

            let responseTime = Date().timeIntervalSince(requestDate)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidData
            }

            logger.log(response: response, data: data, time: responseTime)

            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }

            guard case 200 ... 300 = httpResponse.statusCode else {
                throw APIError.responseUnsuccessful
            }

            return try decodeData(data, decode: T.self)
        } catch let error as URLError where error.code == .cancelled {
            throw APIError.requestCancelled
        } catch is CancellationError {
            throw APIError.requestCancelled
        } catch {
            throw error
        }
    }

    func request<T: Decodable>(_ endpoint: EndpointProtocol, decode: T.Type) async throws -> T {
        guard endpoint.needsToken, let token = keychain.oauthToken else {
            return try await request(endpoint.request, decode: T.self)
        }

        do {
            return try await request(authorizedRequest(endpoint, token: token), decode: T.self)
        } catch APIError.unauthorized {
            let refreshedToken = try await refresh(token)
            return try await request(authorizedRequest(endpoint, token: refreshedToken), decode: T.self)
        }
    }

    func cancelRequest(_ request: URLRequest?) {
        guard let request else { return }
        activeTasks.removeValue(forKey: request)?.cancel()
    }

    // MARK: - Helper

    private func authorizedRequest(_ endpoint: EndpointProtocol, token: OAuthTokenDTO) -> URLRequest {
        var request = endpoint.request
        request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    private func refresh(_ token: OAuthTokenDTO) async throws -> OAuthTokenDTO {
        if let refreshTask {
            return try await refreshTask.value
        }

        let endpoint: AuthEndpoint = .refresh(clientID: clientID, clientSecret: clientSecret, refreshToken: token.refreshToken)
        let task = Task {
            do {
                let refreshedToken = try await request(endpoint.request, decode: OAuthTokenDTO.self)
                try keychain.set(JSONEncoder().encode(refreshedToken), for: OAuthTokenDTO.keychainKey)
                return refreshedToken
            } catch APIError.unauthorized, APIError.responseUnsuccessful {
                keychain.delete(OAuthTokenDTO.keychainKey)
                throw APIError.unauthorized
            }
        }
        refreshTask = task
        defer { refreshTask = nil }

        return try await task.value
    }

    private func decodeData<T: Decodable>(_ data: Data, decode: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            throw APIError.keyNotFound(key: key, context: context.debugDescription)
        } catch let DecodingError.valueNotFound(type, context) {
            throw APIError.valueNotFound(type: type, context: context.debugDescription)
        } catch let DecodingError.typeMismatch(type, context) {
            throw APIError.typeMismatch(type: type, context: context.debugDescription)
        } catch let DecodingError.dataCorrupted(context) {
            throw APIError.dataCorrupted(context: context.debugDescription)
        }
    }
}
