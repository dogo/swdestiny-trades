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

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        loadCollection()
    }

    func loadCollection() {
        setLoading(true)
        loadCollectionFromDatabase()
    }

    var shareText: String {
        var text = "\(L10n.myCollection)\n\n"
        for card in filteredItems.filter({ $0.quantity > 0 }) {
            text += "\(card.quantity)x \(card.name)\n"
        }
        return text
    }

    func refreshCollection() async {
        setLoading(true)
        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)
        if let userCollection = collections.first {
            updateItems(userCollection.myCollection)
        } else {
            updateItems([])
        }
        setLoaded()
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
                card.name.localizedStandardContains(searchText)
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

                let cardIDToRemove = card.id
                if let index = userCollection.myCollection.firstIndex(where: { $0.id == cardIDToRemove }) {
                    userCollection.myCollection.remove(at: index)
                }
                try await database.save(object: userCollection, update: .modified)
            } catch is CancellationError {
                return
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }
}
