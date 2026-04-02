//
//  AddCardViewModel.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class AddCardViewModel: ListViewModel<CardDTO> {

    var filter: UnifiedCardFilter = .init()
    var availableSets: [SetDTO] = []

    private var isInitialLoadComplete = false

    var addCardContext: AddCardContext

    private var service: SWDestinyServiceProtocol {
        dependencyContainer.resolve(type: SWDestinyServiceProtocol.self)
    }

    private var database: DatabaseProtocol {
        dependencyContainer.resolve(type: DatabaseProtocol.self)
    }

    init(context: AddCardContext, dependencyContainer: DependencyContainer = .shared) {
        addCardContext = context
        super.init(dependencyContainer: dependencyContainer)

        Task { @MainActor in
            switch context {
            case let .person(id, type):
                await loadPersonContext(id: id, type: type)
            case .collection:
                await loadOrCreateUserCollection()
            case .lentToPerson, .borrowedFromPerson:
                break
            }
            await loadAllCards()
            await loadAvailableSets()
            isInitialLoadComplete = true
        }
    }

    required init(dependencyContainer: DependencyContainer = .shared) {
        addCardContext = .collection(UserCollectionDTO())
        super.init(dependencyContainer: dependencyContainer)

        Task { @MainActor in
            await loadOrCreateUserCollection()
        }
    }

    override func loadItems(page: Int = 0, reset: Bool = false) async {
        await loadAllCards()
    }

    func loadData() async {
        guard !isInitialLoadComplete else { return }

        switch addCardContext {
        case let .person(id, type):
            await loadPersonContext(id: id, type: type)
        case .collection:
            await loadOrCreateUserCollection()
        case .lentToPerson, .borrowedFromPerson:
            break
        }
        await loadAllCards()
        await loadAvailableSets()
    }

    private func loadPersonContext(id: String, type: AddCardType) async {
        let people = await database.fetch(PersonDTO.self, predicate: nil, sorted: nil)
        if let person = people.first(where: { $0.id == id }) {
            switch type {
            case .lent:
                addCardContext = .lentToPerson(person)
            case .borrow:
                addCardContext = .borrowedFromPerson(person)
            case .collection:
                await loadOrCreateUserCollection()
            }
        }
    }

    private func loadOrCreateUserCollection() async {
        let collections = await database.fetch(UserCollectionDTO.self, predicate: nil, sorted: nil)

        if let existingCollection = collections.first {
            addCardContext = .collection(existingCollection)
        } else {
            let newCollection = UserCollectionDTO()
            do {
                _ = try await database.create(UserCollectionDTO.self, value: newCollection, update: .error)
                addCardContext = .collection(newCollection)
            } catch {
                handleError(error)
            }
        }
    }

    func loadAllCards() async {
        setLoading(true)

        do {
            try Task.checkCancellation()

            let allCards = try await service.retrieveAllCards()

            try Task.checkCancellation()

            updateItems(allCards)
            setLoaded()
        } catch is CancellationError {
            setLoaded()
        } catch {
            handleError(error)
        }
    }

    func applyFilters() {
        performFiltering(searchText: searchText)
    }

    private func loadAvailableSets() async {
        let sets = await database.fetch(SetDTO.self, predicate: nil, sorted: nil)
        availableSets = sets.sorted { $0.name < $1.name }
    }

    override func filterItems(searchText: String) -> [CardDTO] {
        var filtered = items

        if !searchText.isEmpty {
            filtered = filtered.filter { card in
                card.name.localizedStandardContains(searchText) ||
                    card.subtitle.localizedStandardContains(searchText)
            }
        }

        if let selectedSet = filter.selectedSet {
            filtered = filtered.filter { card in
                card.setCode == selectedSet.code
            }
        }

        if !filter.selectedTypes.isEmpty {
            filtered = filtered.filter { card in
                filter.selectedTypes.contains(card.typeCode)
            }
        }

        if !filter.selectedColors.isEmpty {
            filtered = filtered.filter { card in
                filter.selectedColors.contains(card.factionCode)
            }
        }

        filtered = filterExistingCards(filtered)

        return filtered
    }

    private func filterExistingCards(_ cards: [CardDTO]) -> [CardDTO] {
        let existingCodes: Set<String>

        switch addCardContext {
        case let .collection(userCollection):
            existingCodes = Set(userCollection.myCollection.map(\.code))
        case let .lentToPerson(person):
            existingCodes = Set(person.lentMe.map(\.code))
        case let .borrowedFromPerson(person):
            existingCodes = Set(person.borrowed.map(\.code))
        case .person:
            return cards
        }

        return cards.filter { !existingCodes.contains($0.code) }
    }

    func addCard(_ card: CardDTO) {
        Task { @MainActor in
            do {
                switch addCardContext {
                case let .collection(userCollection):
                    try await addCardToCollection(card, userCollection: userCollection, database: database)
                case let .lentToPerson(person):
                    try await addCardToLentMe(card, person: person, database: database)
                case let .borrowedFromPerson(person):
                    try await addCardToBorrowed(card, person: person, database: database)
                case .person:
                    return
                }

                toastQueue.enqueue(title: L10n.cardAdded, message: L10n.cardAddedSuccessfully(card.name), type: .success)
                self.performFiltering(searchText: self.searchText)
            } catch is CancellationError {
                return
            } catch {
                toastQueue.enqueue(
                    title: L10n.error,
                    message: (error as? AddCardError)?.localizedDescription ?? error.localizedDescription,
                    type: .error,
                    duration: 2.5
                )
            }
        }
    }

    private func addCardToCollection(_ card: CardDTO, userCollection: UserCollectionDTO, database: DatabaseProtocol) async throws {
        if userCollection.myCollection.contains(where: { $0.code == card.code }) {
            throw AddCardError.alreadyAdded
        }

        let cardCopy = CardDTO(copying: card)
        cardCopy.id = UUID().uuidString

        userCollection.myCollection.append(cardCopy)
        try await database.save(object: userCollection, update: .modified)
    }

    private func addCardToLentMe(_ card: CardDTO, person: PersonDTO, database: DatabaseProtocol) async throws {
        if person.lentMe.contains(where: { $0.code == card.code }) {
            throw AddCardError.alreadyAdded
        }

        let cardCopy = CardDTO(copying: card)
        cardCopy.id = UUID().uuidString

        person.lentMe.append(cardCopy)
        try await database.save(object: person, update: .modified)
    }

    private func addCardToBorrowed(_ card: CardDTO, person: PersonDTO, database: DatabaseProtocol) async throws {
        if person.borrowed.contains(where: { $0.code == card.code }) {
            throw AddCardError.alreadyAdded
        }

        let cardCopy = CardDTO(copying: card)
        cardCopy.id = UUID().uuidString

        person.borrowed.append(cardCopy)
        try await database.save(object: person, update: .modified)
    }

    override func handleError(_ error: Error) {
        if ConcurrencyError.isCancellation(error) {
            return
        }
        super.handleError(error)
    }
}

enum AddCardContext {
    case collection(UserCollectionDTO)
    case lentToPerson(PersonDTO)
    case borrowedFromPerson(PersonDTO)
    case person(id: String, type: AddCardType)

    var title: String {
        switch self {
        case .collection:
            return L10n.addCard
        case .lentToPerson:
            return L10n.addLentCard
        case .borrowedFromPerson:
            return L10n.addBorrowedCard
        case let .person(_, type):
            switch type {
            case .lent:
                return L10n.addLentCard
            case .borrow:
                return L10n.addBorrowedCard
            case .collection:
                return L10n.addCard
            }
        }
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
