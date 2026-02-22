//
//  AppState.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
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

    private var cancellables = Set<AnyCancellable>()

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
                let database = try await RealmManager.create(configuration: .basic(url: nil))
                RealmMigrations.performMigrations(with: database)
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
            HttpClient()
        }

        dependencyContainer.register(type: SWDestinyServiceProtocol.self) {
            let httpClient: HttpClientProtocol = self.dependencyContainer.resolve(type: HttpClientProtocol.self)
            return SWDestinyService(client: httpClient)
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
