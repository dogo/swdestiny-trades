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
        showToast = true
        setLoaded()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        super.init(dependencyContainer: dependencyContainer)
    }

    override func loadItems(page: Int = 0, reset: Bool = false) {
        Task {
            await loadCardsAsync()
        }
    }

    func loadCards() {
        Task {
            await loadCardsAsync()
        }
    }

    func loadCardsAsync() async {
        guard let set = selectedSet else {
            handleError(ViewModelError.dataLoadingFailed("No set selected"))
            return
        }

        setLoading(true)
        await loadCardsFromDatabase(for: set)
    }

    private func loadCardsFromDatabase(for set: SetDTO) async {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        let setCode = set.code
        let allCards = await database.fetch(CardDTO.self, predicate: nil, sorted: nil)
        let setCards = allCards.filter { $0.setCode == setCode }

        updateItems(setCards)
        setLoaded()

        if setCards.isEmpty {
            await fetchCardsFromAPI(for: set)
        }
    }

    private func fetchCardsFromAPI(for set: SetDTO) async {
        guard let service = swDestinyService else {
            handleError(ViewModelError.serviceNotAvailable)
            return
        }

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
