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
final class UserCollectionViewModel: ListViewModel<CardDTO> {

    @Published var sortOption: CollectionSortOption = .name

    @Published var filterOptions: CollectionFilterOptions = .init()

    @Published var selectedSet: SetDTO?

    // Toast properties
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    @Published var availableSets: [SetDTO] = []

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
        setupFilterObserver()
        loadCollection()
        loadAvailableSets()
    }

    private func setupFilterObserver() {
        Publishers.CombineLatest3($sortOption, $filterOptions, $selectedSet)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _, _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        DispatchQueue.main.async {
            self.showToast = false

            self.toastTitle = "Error"
            self.toastMessage = error.localizedDescription
            self.toastType = .error

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showToast = true
            }
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
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        DispatchQueue.main.async {
            do {
                try database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil) { userCollections in
                    let allCards = userCollections.flatMap(\.myCollection)

                    self.updateItems(Array(allCards))
                    self.setLoaded()
                }
            } catch {
                self.handleError(error)
            }
        }
    }

    private func loadAvailableSets() {
        guard let database else { return }

        DispatchQueue.main.async {
            do {
                try database.fetch(SetDTO.self, predicate: nil, sorted: nil) { sets in
                    let setData = Array(sets).threadSafeMap { $0.toThreadSafe() }
                    let sortedData = setData.sorted { $0.name < $1.name }

                    let sortedSets = sortedData.compactMap { setData in
                        sets.first { $0.id == setData.id }
                    }

                    self.availableSets = sortedSets
                }
            } catch {
                print("Failed to load sets for filtering: \(error)")
            }
        }
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

    func updateCardQuantity(_ card: CardDTO, quantity: Int) {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        DispatchQueue.main.async {
            do {
                try database.update {
                    card.quantity = max(0, quantity)
                }
                self.loadCollection()
            } catch {
                self.handleError(error)
            }
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
