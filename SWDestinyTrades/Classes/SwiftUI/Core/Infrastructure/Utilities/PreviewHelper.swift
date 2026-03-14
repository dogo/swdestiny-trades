//
//  PreviewHelper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@MainActor
enum PreviewHelper {
    static func createContainer() async throws -> DependencyContainer {
        let container = DependencyContainer.shared

        let database = try await createMockDatabase()
        container.register(type: DatabaseProtocol.self) {
            database
        }

        container.register(type: HttpClientProtocol.self) {
            PreviewHttpClientMock()
        }

        return container
    }

    static func createMockDatabase() async throws -> SwiftDataManager {
        let database = try await SwiftDataManager.create(inMemory: true)

        for card in SampleData.cards {
            try await database.save(object: card, update: .all)
        }

        for set in SampleData.sets {
            try await database.save(object: set, update: .all)
        }

        for deck in SampleData.decks {
            try await database.save(object: deck, update: .all)
        }

        for person in SampleData.people {
            try await database.save(object: person, update: .all)
        }

        return database
    }

    static func createAppState() async throws -> AppState {
        let appState = AppState()
        appState.database = try await createMockDatabase()
        appState.isInitialized = true
        return appState
    }
}

final class PreviewHttpClientMock: HttpClientProtocol {
    var logger: NetworkingLogger {
        return NetworkingLogger(level: .none)
    }

    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {
        throw APIError.invalidData
    }

    func cancelRequest(_ request: URLRequest?) {}
}
