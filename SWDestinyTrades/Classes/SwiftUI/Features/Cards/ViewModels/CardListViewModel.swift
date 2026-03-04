//
//  CardListViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

// MARK: - CardListViewModel

@MainActor
@Observable
final class CardListViewModel: ListViewModel<CardDTO> {

    var selectedSet: SetDTO?
    var filter: UnifiedCardFilter = .init()

    var showToast = false
    var toastTitle = ""
    var toastMessage = ""
    var toastType: ToastType = .info

    // MARK: - Computed Properties

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

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        await loadCards()
    }

    func loadCards() async {
        guard let set = selectedSet else {
            handleError(CardListError.noSetSelected)
            return
        }

        setLoading(true)
        await fetchCardsFromAPI(for: set)
    }

    // MARK: - Private Methods

    private func applyFilters() {
        performFiltering(searchText: searchText)
    }

    private func fetchCardsFromAPI(for set: SetDTO) async {
        let setCode = set.code.lowercased()

        do {
            try Task.checkCancellation()

            let cards = try await service.retrieveSetCardList(setCode: setCode)

            try Task.checkCancellation()

            updateItems(cards)
            setLoaded()
        } catch is CancellationError {
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

            let matchesColor = filter.selectedColors.isEmpty ||
                filter.selectedColors.contains(card.factionCode)

            let matchesType = filter.selectedTypes.isEmpty ||
                filter.selectedTypes.contains(card.typeCode)

            return matchesSearch && matchesColor && matchesType
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
