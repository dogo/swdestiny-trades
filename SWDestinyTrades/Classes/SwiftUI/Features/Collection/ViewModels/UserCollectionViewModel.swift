//
//  UserCollectionViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class UserCollectionViewModel: ListViewModel<CardDTO> {

    var sortOption: CollectionSortOption = .name
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
                    let allCards = Array(userCollection.myCollection)
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

    private func applySorting(to collection: [CardDTO]) -> [CardDTO] {
        switch sortOption {
        case .name:
            return collection.sorted { $0.name < $1.name }
        case .set:
            return collection.sorted { $0.setCode < $1.setCode }
        case .type:
            return collection.sorted { $0.typeCode < $1.typeCode }
        case .color:
            return collection.sorted { $0.factionCode < $1.factionCode }
        case .quantity:
            return collection.sorted { card1, card2 in
                ThreadSafeRealmWrapper.execute {
                    card1.quantity > card2.quantity
                }
            }
        case .cost:
            return collection.sorted { $0.cost < $1.cost }
        }
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

        // Apply sorting
        filtered = applySorting(to: filtered)

        return filtered
    }

    func updateSortOption(_ option: CollectionSortOption) {
        sortOption = option
    }

    func updateCardQuantity(_ card: CardDTO, quantity: Int) async {
        do {
            guard let managedCard = await database.fetchByKey(CardDTO.self, key: card.id) else {
                handleError(ViewModelError.objectNotFound)
                return
            }

            let newQuantity = max(0, quantity)

            try await database.update {
                managedCard.quantity = newQuantity
            }
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

                guard let cardIndex = userCollection.myCollection.firstIndex(where: { $0.id == card.id }) else {
                    handleError(ViewModelError.objectNotFound)
                    return
                }

                try await database.update {
                    userCollection.myCollection.remove(at: cardIndex)
                }
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }
}

enum CollectionSortOption: CaseIterable {
    case name
    case set
    case type
    case color
    case quantity
    case cost

    var displayName: String {
        switch self {
        case .name:
            L10n.name
        case .set:
            L10n.set
        case .type:
            L10n.type
        case .color:
            L10n.color
        case .quantity:
            L10n.quantity
        case .cost:
            L10n.cost
        }
    }
}
