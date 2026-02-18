//
//  CardListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

// MARK: - CardListViewModel

@MainActor
@Observable
final class CardListViewModel: ListViewModel<CardDTO> {

    var selectedSet: SetDTO?
    var filterOptions: CardFilterOptions = .init()

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    // MARK: - Computed Properties

    var availableColorNames: [FilterOption] {
        let uniqueColors = Dictionary(grouping: items) { $0.factionCode }
            .compactMap { code, cards -> FilterOption? in
                guard let first = cards.first else { return nil }
                return FilterOption(code: code, name: first.factionCode)
            }
        return uniqueColors.sorted { $0.name < $1.name }
    }

    var availableTypeNames: [FilterOption] {
        let uniqueTypes = Dictionary(grouping: items) { $0.typeCode }
            .compactMap { code, cards -> FilterOption? in
                guard let first = cards.first else { return nil }
                return FilterOption(code: code, name: first.typeName)
            }
        return uniqueTypes.sorted { $0.name < $1.name }
    }

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    private var service: SWDestinyServiceProtocol {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    // MARK: - Initialization

    init(set: SetDTO, dependencyContainer: DependencyContainer = .shared) {
        selectedSet = set
        super.init(dependencyContainer: dependencyContainer)
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    // MARK: - Error handling

    override func handleError(_ error: Error) {
        showToast = false
        toastTitle = L10n.error

        if ConcurrencyError.isCancellation(error) {
            setLoaded()
            return
        }

        toastMessage = error.localizedDescription
        toastType = .error
        showToast = true
        setLoaded()
    }

    // MARK: - Internal Methods

    override func loadItems(page: Int = 0, reset: Bool = false) {
        Task {
            await loadCards()
        }
    }

    func loadCards() async {
        guard let set = selectedSet else {
            handleError(CardListError.noSetSelected)
            return
        }

        setLoading(true)
        await loadCardsFromDatabase(for: set)
    }

    // MARK: - Private Methods

    private func applyFilters() {
        performFiltering(searchText: searchText)
    }

    private func loadCardsFromDatabase(for set: SetDTO) async {
        let allCards = await database.fetch(CardDTO.self, predicate: nil, sorted: nil)
        let setCards = allCards.filter { $0.setCode == set.code }

        updateItems(setCards)
        setLoaded()

        if setCards.isEmpty {
            await fetchCardsFromAPI(for: set)
        }
    }

    private func fetchCardsFromAPI(for set: SetDTO) async {
        setLoading(true)

        let setCode = set.code.lowercased()

        do {
            let cards = try await service.retrieveSetCardList(setCode: setCode)
            updateItems(cards)
            setLoaded()
        } catch {
            handleError(error)
        }
    }

    // MARK: - Filtering

    override func filterItems(searchText: String) -> [CardDTO] {
        items.filter { card in
            let matchesSearch = searchText.isEmpty ||
                card.name.localizedCaseInsensitiveContains(searchText) ||
                card.subtitle.localizedCaseInsensitiveContains(searchText)

            let matchesColor = filterOptions.selectedColors.isEmpty ||
                filterOptions.selectedColors.contains(card.factionCode)

            let matchesType = filterOptions.selectedTypes.isEmpty ||
                filterOptions.selectedTypes.contains(card.typeCode)

            let matchesMinCost = filterOptions.minCost.map { card.cost >= $0 } ?? true
            let matchesMaxCost = filterOptions.maxCost.map { card.cost <= $0 } ?? true

            return matchesSearch && matchesColor && matchesType &&
                matchesMinCost && matchesMaxCost
        }
    }
}

// MARK: - CardListError

enum CardListError: Error, LocalizedError {
    case noSetSelected
    case databaseNotAvailable
    case serviceNotAvailable
    case dataLoadingFailed(String)

    var errorDescription: String? {
        switch self {
        case .noSetSelected:
            return "No set selected"
        case .databaseNotAvailable:
            return "Database not available"
        case .serviceNotAvailable:
            return "Service not available"
        case let .dataLoadingFailed(message):
            return message
        }
    }
}

// MARK: - CardFilterOptions

struct CardFilterOptions: Equatable {
    var selectedColors: Set<String> = []
    var selectedTypes: Set<String> = []
    var minCost: Int?
    var maxCost: Int?

    var hasActiveFilters: Bool {
        !selectedColors.isEmpty ||
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

// MARK: - FilterOption

struct FilterOption: Identifiable, Equatable {
    let code: String
    let name: String

    var id: String { code }
}
