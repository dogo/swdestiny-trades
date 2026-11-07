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

    let dependencyContainer = DependencyContainer.shared

    init() {
        setupInitialState()
    }

    func initialize() {
        guard !isInitialized, !isLoading else { return }

        isLoading = true
        initializeDatabase()
    }

    private func setupInitialState() {
        isLoading = false
        isInitialized = false
    }

    private func initializeDatabase() {
        Task { @MainActor in
            do {
                let database = try await SwiftDataManager.create()
                self.database = database
                isInitialized = true
                errorMessage = nil

                dependencyContainer.register(type: DatabaseProtocol.self) {
                    database
                }

                registerServices()
            } catch {
                errorMessage = "Failed to initialize database: \(error.localizedDescription)"
                isInitialized = false
            }
            isLoading = false
        }
    }

    private func registerServices() {
        dependencyContainer.register(type: HttpClientProtocol.self) {
            let authService: AuthServiceProtocol = DependencyContainer.shared.resolve(type: AuthServiceProtocol.self)
            return AuthenticatedHttpClient(client: HttpClient(), authService: authService)
        }

        dependencyContainer.register(type: SetServiceProtocol.self) {
            let httpClient: HttpClientProtocol = DependencyContainer.shared.resolve(type: HttpClientProtocol.self)
            return SetService(client: httpClient)
        }

        dependencyContainer.register(type: CardServiceProtocol.self) {
            let httpClient: HttpClientProtocol = DependencyContainer.shared.resolve(type: HttpClientProtocol.self)
            return CardService(client: httpClient)
        }

        dependencyContainer.register(type: SearchServiceProtocol.self) {
            let httpClient: HttpClientProtocol = DependencyContainer.shared.resolve(type: HttpClientProtocol.self)
            return SearchService(client: httpClient)
        }

        dependencyContainer.register(type: AuthServiceProtocol.self) {
            AuthService(client: HttpClient())
        }

        dependencyContainer.register(type: DeckServiceProtocol.self) {
            let httpClient: HttpClientProtocol = DependencyContainer.shared.resolve(type: HttpClientProtocol.self)
            return DeckService(client: httpClient)
        }

        dependencyContainer.register(type: ImageLoadingService.self) {
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
