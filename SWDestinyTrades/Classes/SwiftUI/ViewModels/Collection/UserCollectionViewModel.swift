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
    var filterOptions: CollectionFilterOptions = .init()
    var selectedSet: SetDTO?
    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info
    var availableSets: [SetDTO] = []

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    @ObservationIgnored private nonisolated(unsafe) var observationTask: Task<Void, Never>?

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        showToast = false
        toastTitle = "Error"
        toastMessage = error.localizedDescription
        toastType = .error

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            showToast = true
        }
    }

    override func loadItems(page: Int = 0, reset: Bool = false) {
        loadCollection()
    }

    func loadCollection() {
        setLoading(true)
        loadCollectionFromDatabase()
    }

    private func applyFilters() {
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
        if let selectedSet {
            filtered = filtered.filter { card in
                card.setCode == selectedSet.code
            }
        }

        // Apply color filters
        if !filterOptions.selectedColors.isEmpty {
            filtered = filtered.filter { card in
                filterOptions.selectedColors.contains(card.factionCode)
            }
        }

        // Apply type filters
        if !filterOptions.selectedTypes.isEmpty {
            filtered = filtered.filter { card in
                filterOptions.selectedTypes.contains(card.typeCode)
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

    func updateFilterOptions(_ options: CollectionFilterOptions) {
        filterOptions = options
    }

    func updateSelectedSet(_ set: SetDTO?) {
        selectedSet = set
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
}

enum CollectionSortOption: String, CaseIterable {
    case name = "Name"
    case set = "Set"
    case type = "Type"
    case color = "Color"
    case quantity = "Quantity"
    case cost = "Cost"

    var displayName: String {
        return rawValue
    }
}

struct CollectionFilterOptions: Equatable {
    var selectedColors: Set<String> = []
    var selectedTypes: Set<String> = []

    var hasActiveFilters: Bool {
        return !selectedColors.isEmpty ||
            !selectedTypes.isEmpty
    }

    mutating func clearAll() {
        selectedColors.removeAll()
        selectedTypes.removeAll()
    }
}
