//
//  AddCardViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
final class AddCardViewModel: ListViewModel<CardDTO> {

    @Published var selectedFilters: AddCardFilters = .init()
    @Published var availableSets: [SetDTO] = []

    // Toast properties
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info

    let addCardContext: AddCardContext

    private var service: SWDestinyServiceProtocol? {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var database: DatabaseProtocol? {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(context: AddCardContext, dependencyContainer: DependencyContainer = .shared) {
        addCardContext = context
        super.init(dependencyContainer: dependencyContainer)

        $selectedFilters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)

        loadAllCards()
        loadAvailableSets()
    }

    init(personId: String, type: AddCardType, dependencyContainer: DependencyContainer = .shared) {
        let database = dependencyContainer.resolve(type: DatabaseProtocol.self)
        var person: PersonDTO?

        try? database.fetch(PersonDTO.self, predicate: nil, sorted: nil) { people in
            person = people.first { $0.id == personId }
        }

        if let person {
            switch type {
            case .lent:
                addCardContext = .lentToPerson(person)
            case .borrow:
                addCardContext = .borrowedFromPerson(person)
            case .collection:
                addCardContext = .collection(UserCollectionDTO())
            }
        } else {
            addCardContext = .collection(UserCollectionDTO())
        }

        super.init(dependencyContainer: dependencyContainer)

        $selectedFilters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)

        loadAllCards()
        loadAvailableSets()
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        addCardContext = .collection(UserCollectionDTO())
        super.init(dependencyContainer: dependencyContainer)
    }

    override func loadItems(page: Int = 0, reset: Bool = false) {
        loadAllCards()
    }

    func loadAllCards() {
        setLoading(true)

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                guard let service else {
                    throw ViewModelError.serviceNotAvailable
                }

                let allCards = try await service.retrieveAllCards()

                try Task.checkCancellation()

                self.updateItems(allCards)
                self.setLoaded()
            } catch is CancellationError {
                self.setLoaded()
            } catch {
                self.handleError(error)
            }
        }
    }

    private func applyFilters() {
        performFiltering(searchText: searchText)
    }

    private func loadAvailableSets() {
        guard let database else { return }

        Task { @MainActor in
            do {
                try database.fetch(SetDTO.self, predicate: nil, sorted: nil) { [weak self] sets in
                    let setData = Array(sets).threadSafeMap { $0.toThreadSafe() }
                    let sortedData = setData.sorted { $0.name < $1.name }

                    let sortedSets = sortedData.compactMap { setData in
                        sets.first { $0.id == setData.id }
                    }

                    self?.availableSets = sortedSets
                }
            } catch {
                print("Failed to load sets for filtering: \(error)")
            }
        }
    }

    override func filterItems(searchText: String) -> [CardDTO] {
        var filtered = items

        if !searchText.isEmpty {
            filtered = filtered.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText) ||
                    card.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let selectedSet = selectedFilters.selectedSet {
            filtered = filtered.filter { card in
                card.setCode == selectedSet.code
            }
        }

        if !selectedFilters.selectedTypes.isEmpty {
            filtered = filtered.filter { card in
                selectedFilters.selectedTypes.contains(card.typeCode)
            }
        }

        if !selectedFilters.selectedColors.isEmpty {
            filtered = filtered.filter { card in
                selectedFilters.selectedColors.contains(card.factionCode)
            }
        }

        if let minCost = selectedFilters.minCost {
            filtered = filtered.filter { card in
                card.cost >= minCost
            }
        }

        if let maxCost = selectedFilters.maxCost {
            filtered = filtered.filter { card in
                card.cost <= maxCost
            }
        }

        filtered = filterExistingCards(filtered)

        return filtered
    }

    private func filterExistingCards(_ cards: [CardDTO]) -> [CardDTO] {
        switch addCardContext {
        case let .collection(userCollection):
            return cards.filter { card in
                !userCollection.myCollection.contains { $0.code == card.code }
            }
        case let .lentToPerson(person):
            return cards.filter { card in
                !person.lentMe.contains { $0.code == card.code }
            }
        case let .borrowedFromPerson(person):
            return cards.filter { card in
                !person.borrowed.contains { $0.code == card.code }
            }
        }
    }

    func addCard(_ card: CardDTO) {
        guard let database else {
            handleError(ViewModelError.databaseNotAvailable)
            return
        }

        Task { @MainActor in
            do {
                try Task.checkCancellation()

                switch addCardContext {
                case let .collection(userCollection):
                    try addCardToCollection(card, userCollection: userCollection, database: database)
                case let .lentToPerson(person):
                    try addCardToLentMe(card, person: person, database: database)
                case let .borrowedFromPerson(person):
                    try addCardToBorrowed(card, person: person, database: database)
                }

                self.showToast = false
                self.toastTitle = "Card Added"
                self.toastMessage = "\(card.name) has been added successfully!"
                self.toastType = .success

                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                self.showToast = true
                self.refresh()
            } catch is CancellationError {
                return
            } catch {
                self.showToast = false
                self.toastTitle = "Error"
                self.toastMessage = (error as? AddCardError)?.localizedDescription ?? error.localizedDescription
                self.toastType = .error

                do {
                    try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                    self.showToast = true
                } catch {
                    // Ignore cancellation during toast delay
                }
            }
        }
    }

    private func addCardToCollection(_ card: CardDTO, userCollection: UserCollectionDTO, database: DatabaseProtocol) throws {
        if userCollection.myCollection.contains(where: { $0.code == card.code }) {
            throw AddCardError.alreadyAdded
        }

        try database.update {
            userCollection.myCollection.append(card)
        }
    }

    private func addCardToLentMe(_ card: CardDTO, person: PersonDTO, database: DatabaseProtocol) throws {
        if person.lentMe.contains(where: { $0.code == card.code }) {
            throw AddCardError.alreadyAdded
        }

        try database.update {
            person.lentMe.append(card)
        }

        let personDataDict: [String: PersonDTO] = ["personDTO": person]
        NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
    }

    private func addCardToBorrowed(_ card: CardDTO, person: PersonDTO, database: DatabaseProtocol) throws {
        if person.borrowed.contains(where: { $0.code == card.code }) {
            throw AddCardError.alreadyAdded
        }

        try database.update {
            person.borrowed.append(card)
        }

        let personDataDict: [String: PersonDTO] = ["personDTO": person]
        NotificationCenter.default.post(name: NotificationKey.reloadTableViewNotification, object: nil, userInfo: personDataDict)
    }

    override func handleError(_ error: Error) {
        super.handleError(error)

        showToast = false

        if ConcurrencyError.isCancellation(error) {
            return
        }

        toastTitle = "Error"
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
    }
}

enum AddCardContext {
    case collection(UserCollectionDTO)
    case lentToPerson(PersonDTO)
    case borrowedFromPerson(PersonDTO)

    var title: String {
        switch self {
        case .collection:
            return L10n.addCard
        case .lentToPerson:
            return "Add Lent Card"
        case .borrowedFromPerson:
            return "Add Borrowed Card"
        }
    }
}

struct AddCardFilters {
    var selectedSet: SetDTO?
    var selectedTypes: Set<String> = []
    var selectedColors: Set<String> = []
    var minCost: Int?
    var maxCost: Int?

    var hasActiveFilters: Bool {
        return selectedSet != nil ||
            !selectedTypes.isEmpty ||
            !selectedColors.isEmpty ||
            minCost != nil ||
            maxCost != nil
    }

    mutating func clearAll() {
        selectedSet = nil
        selectedTypes.removeAll()
        selectedColors.removeAll()
        minCost = nil
        maxCost = nil
    }
}

enum AddCardError: Error, LocalizedError {
    case alreadyAdded
    case networkError
    case databaseError

    var errorDescription: String? {
        switch self {
        case .alreadyAdded:
            return L10n.alreadyAdded
        case .networkError:
            return "Network error occurred"
        case .databaseError:
            return "Database error occurred"
        }
    }
}
