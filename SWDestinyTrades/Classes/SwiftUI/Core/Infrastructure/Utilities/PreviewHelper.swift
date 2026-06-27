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
            try await database.save(object: copyDeck(deck), update: .all)
        }

        for person in SampleData.people {
            try await database.save(object: copyPerson(person), update: .all)
        }

        return database
    }

    static func createAppState() async throws -> AppState {
        let appState = AppState()
        appState.database = try await createMockDatabase()
        appState.isInitialized = true
        return appState
    }

    private static func copyDeck(_ deck: DeckDTO) -> DeckDTO {
        let copy = DeckDTO()
        copy.id = deck.id
        copy.name = deck.name
        copy.list = deck.list.map(CardDTO.init(copying:))
        return copy
    }

    private static func copyPerson(_ person: PersonDTO) -> PersonDTO {
        let copy = PersonDTO()
        copy.id = person.id
        copy.name = person.name
        copy.lastName = person.lastName
        copy.lentMe = person.lentMe.map(CardDTO.init(copying:))
        copy.borrowed = person.borrowed.map(CardDTO.init(copying:))
        return copy
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
