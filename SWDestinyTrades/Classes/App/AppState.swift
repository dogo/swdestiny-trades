//
//  AppState.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class AppState {
    var database: DatabaseProtocol?
    var isInitialized = false
    var isLoading = false
    var errorMessage: String?

    let dependencyContainer: DependencyContainer
    private let makeDatabase: () async throws -> DatabaseProtocol

    init(dependencyContainer: DependencyContainer = .shared,
         makeDatabase: @escaping () async throws -> DatabaseProtocol = { try await SwiftDataManager.create() }) {
        self.dependencyContainer = dependencyContainer
        self.makeDatabase = makeDatabase
        setupInitialState()
    }

    func initialize() {
        guard !isInitialized, !isLoading else { return }

        isLoading = true
        registerServices()
        initializeDatabase()
    }

    private func setupInitialState() {
        isLoading = false
        isInitialized = false
    }

    private func initializeDatabase() {
        Task { @MainActor in
            do {
                let database = try await makeDatabase()
                self.database = database
                isInitialized = true
                errorMessage = nil

                dependencyContainer.register(type: DatabaseProtocol.self) {
                    database
                }
            } catch {
                errorMessage = "Failed to initialize database: \(error.localizedDescription)"
                isInitialized = false
            }
            isLoading = false
        }
    }

    private func registerServices() {
        let container = dependencyContainer

        container.register(type: HttpClientProtocol.self) {
            let authService: AuthServiceProtocol = container.resolve(type: AuthServiceProtocol.self)
            return AuthenticatedHttpClient(client: HttpClient(), authService: authService)
        }

        container.register(type: SetServiceProtocol.self) {
            let httpClient: HttpClientProtocol = container.resolve(type: HttpClientProtocol.self)
            return SetService(client: httpClient)
        }

        container.register(type: CardServiceProtocol.self) {
            let httpClient: HttpClientProtocol = container.resolve(type: HttpClientProtocol.self)
            return CardService(client: httpClient)
        }

        container.register(type: SearchServiceProtocol.self) {
            let httpClient: HttpClientProtocol = container.resolve(type: HttpClientProtocol.self)
            return SearchService(client: httpClient)
        }

        container.register(type: AuthServiceProtocol.self) {
            AuthService(client: HttpClient())
        }

        container.register(type: DeckServiceProtocol.self) {
            let httpClient: HttpClientProtocol = container.resolve(type: HttpClientProtocol.self)
            return DeckService(client: httpClient)
        }

        container.register(type: ImageLoadingService.self) {
            KingfisherImageLoader()
        }
    }

    func reset() {
        database = nil
        isInitialized = false
        isLoading = false
        errorMessage = nil
    }
}
