//
//  HttpClient.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 15/08/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

final class HttpClient: HttpClientProtocol {
    private static let logQueue = DispatchQueue(label: "br.com.anykey.swdestiny.networking-log", qos: .utility)

    private let session: URLSession
    private let keychain: KeychainStoreProtocol
    private var activeTasks: [URLRequest: Task<(Data, URLResponse), Error>] = [:]

    init(session: URLSession = .shared,
         keychain: KeychainStoreProtocol = KeychainStore(service: Bundle.main.appBundleIdentifier)) {
        self.session = session
        self.keychain = keychain
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

    private func perform<T: Decodable & SendableMetatype>(_ request: URLRequest, decode: T.Type) async throws -> T {

        let logger = logger
        Self.logQueue.async { logger.log(request: request) }

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

            Self.logQueue.async { logger.log(response: response, data: data, time: responseTime) }

            // Swift 6.4.2 recognizes SendableMetatype captures here but warns on a generic @concurrent call.
            return try await { @concurrent @Sendable () async throws -> sending T in
                if httpResponse.statusCode == 401 {
                    throw APIError.unauthorized
                }

                guard case 200 ... 300 = httpResponse.statusCode else {
                    throw APIError.responseUnsuccessful
                }

                return try Self.decodeData(data, decode: T.self)
            }()
        } catch let error as URLError where error.code == .cancelled {
            throw APIError.requestCancelled
        } catch is CancellationError {
            throw APIError.requestCancelled
        } catch {
            throw error
        }
    }

    func request<T: Decodable & SendableMetatype>(_ endpoint: EndpointProtocol, decode: T.Type) async throws -> T {
        var request = endpoint.request
        if endpoint.needsToken, let accessToken = keychain.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return try await perform(request, decode: T.self)
    }

    func cancelRequest(_ request: URLRequest?) {
        guard let request else { return }
        activeTasks.removeValue(forKey: request)?.cancel()
    }

    // MARK: - Helper

    private nonisolated static func decodeData<T: Decodable & SendableMetatype>(_ data: Data, decode: T.Type) throws -> T {
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
