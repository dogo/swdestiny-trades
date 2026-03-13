//
//  UserCollectionViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class UserCollectionViewModel: ListViewModel<CardDTO> {

    var filter: UnifiedCardFilter = .init()
    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info
    var availableSets: [SetDTO] = []

    var hasActiveFilters: Bool {
        filter.hasActiveFilters
    }

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        toastTitle = L10n.error
        toastMessage = error.localizedDescription
        toastType = .error
        showToast = true
    }

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        loadCollection()
    }

    func loadCollection() {
        setLoading(true)
        loadCollectionFromDatabase()
    }

    func applyFilters() {
        performFiltering(searchText: searchText)
    }

    private func loadCollectionFromDatabase() {
        observationTask?.cancel()

        observationTask = Task { @MainActor in
            let collectionStream = database.observe(
                UserCollectionDTO.self,
                predicate: nil,
                sorted: nil
            )

            for await userCollections in collectionStream {
                guard !Task.isCancelled else { break }

                if let userCollection = userCollections.first {
                    let allCards = userCollection.myCollection
                    updateItems(allCards)
                } else {
                    updateItems([])
                }

                setLoaded()
            }
        }
    }

    func loadAvailableSets() {
        Task { @MainActor in
            let sets = await database.fetch(
                SetDTO.self,
                predicate: nil,
                sorted: Sorted(key: "name", ascending: true)
            )
            availableSets = sets
        }
    }

    deinit {
        observationTask?.cancel()
    }

    override func filterItems(searchText: String) -> [CardDTO] {
        var filtered = items

        // Apply set filter
        if let selectedSet = filter.selectedSet {
            filtered = filtered.filter { card in
                card.setCode == selectedSet.code
            }
        }

        // Apply color filters
        if !filter.selectedColors.isEmpty {
            filtered = filtered.filter { card in
                filter.selectedColors.contains(card.factionCode)
            }
        }

        // Apply type filters
        if !filter.selectedTypes.isEmpty {
            filtered = filtered.filter { card in
                filter.selectedTypes.contains(card.typeCode)
            }
        }

        // Apply search
        if !searchText.isEmpty {
            filtered = filtered.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Sort by name
        filtered = filtered.sorted { $0.name < $1.name }

        return filtered
    }

    func updateCardQuantity(_ card: CardDTO, quantity: Int) async {
        do {
            guard let managedCard = await database.fetchByKey(CardDTO.self, key: card.id) else {
                handleError(ViewModelError.objectNotFound)
                return
            }

            managedCard.quantity = max(0, quantity)
            try await database.save(object: managedCard, update: .modified)
        } catch {
            handleError(error)
        }
    }

    func removeCard(_ card: CardDTO) {
        Task { @MainActor in
            do {
                try Task.checkCancellation()

                let collections = await database.fetch(
                    UserCollectionDTO.self,
                    predicate: nil,
                    sorted: nil
                )

                guard let userCollection = collections.first else {
                    handleError(ViewModelError.objectNotFound)
                    return
                }

                userCollection.myCollection.removeAll { $0.id == card.id }
                try await database.save(object: userCollection, update: .modified)
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }
}
