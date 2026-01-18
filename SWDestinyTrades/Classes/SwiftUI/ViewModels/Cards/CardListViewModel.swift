//
//  CardListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class CardListViewModel: ListViewModel<CardDTO> {

    @Published var selectedSet: SetDTO?
    @Published var filterOptions: CardFilterOptions = .init()

    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    private var swDestinyService: SWDestinyServiceProtocol? {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    init(set: SetDTO, dependencyContainer: DependencyContainer = .shared) {
        selectedSet = set
        super.init(dependencyContainer: dependencyContainer)

        $filterOptions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)

        loadCards()
    }

    private func applyFilters() {
        performFiltering(searchText: searchText)
    }

    override func handleError(_ error: Error) {
        showToast = false

        toastTitle = "Error"

        if ConcurrencyError.isCancellation(error) {
            setLoaded()
            return
        }

        toastMessage = error.localizedDescription
        toastType = .error

        Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                self.showToast = true
            } catch {
                // Ignore cancellation during toast delay
            }
        }

        setLoaded()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func loadItems(page: Int = 0, reset: Bool = false) {
        loadCards()
    }

    func loadCards() {
        guard let set = selectedSet else {
            handleError(ViewModelError.dataLoadingFailed("No set selected"))
            return
        }

        setLoading(true)
        loadCardsFromDatabase(for: set)
    }

    private func loadCardsFromDatabase(for set: SetDTO) {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        let setCode = set.code

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                let allCards = await database.fetch(CardDTO.self, predicate: nil, sorted: nil)
                let setCards = allCards.filter { $0.setCode == setCode }

                self.updateItems(setCards)
                self.setLoaded()

                if setCards.isEmpty {
                    self.fetchCardsFromAPI(for: set)
                }
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(ConcurrencyError.realmAccessError(error))
            }
        }
    }

    private func fetchCardsFromAPI(for set: SetDTO) {
        guard let service = swDestinyService else {
            handleError(ViewModelError.serviceNotAvailable)
            return
        }

        setLoading(true)

        let setCode = set.code.lowercased()

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                let cards = try await service.retrieveSetCardList(setCode: setCode)

                try Task.checkCancellation()

                self.updateItems(cards)
                self.setLoaded()
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(error)
            }
        }
    }

    // MARK: - Filtering

    override func filterItems(searchText: String) -> [CardDTO] {
        var filtered = items

        // Apply search filter first
        if !searchText.isEmpty {
            filtered = filtered.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText) ||
                    card.subtitle.localizedCaseInsensitiveContains(searchText)
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

        // Apply cost filters
        if let minCost = filterOptions.minCost {
            filtered = filtered.filter { card in
                card.cost >= minCost
            }
        }

        if let maxCost = filterOptions.maxCost {
            filtered = filtered.filter { card in
                card.cost <= maxCost
            }
        }

        return filtered
    }
}

struct CardFilterOptions {
    var selectedColors: Set<String> = []
    var selectedTypes: Set<String> = []
    var minCost: Int?
    var maxCost: Int?

    var hasActiveFilters: Bool {
        return !selectedColors.isEmpty ||
            !selectedTypes.isEmpty ||
            minCost != nil ||
            maxCost != nil
    }

    mutating func clearAll() {
        selectedColors.removeAll()
        selectedTypes.removeAll()
        minCost = nil
        maxCost = nil
    }
}
