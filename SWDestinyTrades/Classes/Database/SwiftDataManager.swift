//
//  SwiftDataManager.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 13/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import SwiftData

// MARK: - SwiftDataManagerError

enum SwiftDataManagerError: Error, LocalizedError {
    case initializationFailed(underlying: Error)
    case writeOperationFailed(underlying: Error)
    case unsupportedType(String)

    var errorDescription: String? {
        switch self {
        case let .initializationFailed(error):
            return "Failed to initialize SwiftData: \(error.localizedDescription)"
        case let .writeOperationFailed(error):
            return "Write operation failed: \(error.localizedDescription)"
        case let .unsupportedType(type):
            return "Unsupported storable type: \(type)"
        }
    }
}

// MARK: - SwiftDataManager

@MainActor
final class SwiftDataManager: @MainActor DatabaseProtocol { // swiftlint:disable:this type_body_length

    private let container: ModelContainer

    private var context: ModelContext { container.mainContext }

    private static let didChangeNotification = Notification.Name("SwiftDataManagerDidChange")

    // MARK: - Factory

    static func create(inMemory: Bool = false) async throws -> SwiftDataManager {
        let schema = Schema([CardSD.self, SetSD.self, DeckSD.self, PersonSD.self, UserCollectionSD.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            return SwiftDataManager(container: container)
        } catch {
            throw SwiftDataManagerError.initializationFailed(underlying: error)
        }
    }

    private init(container: ModelContainer) {
        self.container = container
    }

    // MARK: - DatabaseProtocol: Fetch

    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) async -> [T] {
        switch model {
        case is CardDTO.Type:
            return fetchCards(sorted: sorted) as! [T] // swiftlint:disable:this force_cast
        case is SetDTO.Type:
            return fetchSets(sorted: sorted) as! [T] // swiftlint:disable:this force_cast
        case is DeckDTO.Type:
            return fetchDecks(sorted: sorted) as! [T] // swiftlint:disable:this force_cast
        case is PersonDTO.Type:
            return fetchPersons(sorted: sorted) as! [T] // swiftlint:disable:this force_cast
        case is UserCollectionDTO.Type:
            return fetchUserCollections() as! [T] // swiftlint:disable:this force_cast
        default:
            return []
        }
    }

    func fetchByKey<T: Storable>(_ model: T.Type, key: Any) async -> T? {
        guard let keyString = key as? String else { return nil }
        switch model {
        case is CardDTO.Type:
            return findCard(id: keyString).map { cardDTO(from: $0) } as? T
        case is SetDTO.Type:
            return findSet(code: keyString).map { setDTO(from: $0) } as? T
        case is DeckDTO.Type:
            return findDeck(id: keyString).map { deckDTO(from: $0) } as? T
        case is PersonDTO.Type:
            return findPerson(id: keyString).map { personDTO(from: $0) } as? T
        case is UserCollectionDTO.Type:
            return findUserCollection(id: keyString).map { userCollectionDTO(from: $0) } as? T
        default:
            return nil
        }
    }

    // MARK: - DatabaseProtocol: Write

    func create<T: Storable>(_ model: T.Type, value: Any, update: UpdatePolicy) async throws -> T {
        guard let dto = value as? T else {
            throw SwiftDataManagerError.unsupportedType(String(describing: model))
        }
        try upsert(dto)
        try saveContext()
        return dto
    }

    func save(object: Storable, update: UpdatePolicy) async throws {
        try upsert(object)
        try saveContext()
    }

    func delete(object: Storable) async throws {
        switch object {
        case let card as CardDTO:
            if let stored = findCard(id: card.id) { context.delete(stored) }
        case let set as SetDTO:
            if let stored = findSet(code: set.code) { context.delete(stored) }
        case let deck as DeckDTO:
            if let stored = findDeck(id: deck.id) { context.delete(stored) }
        case let person as PersonDTO:
            if let stored = findPerson(id: person.id) { context.delete(stored) }
        case let collection as UserCollectionDTO:
            if let stored = findUserCollection(id: collection.id) { context.delete(stored) }
        default:
            break
        }
        try saveContext()
    }

    func deleteAll(_ model: (some Storable).Type) async throws {
        switch model {
        case is CardDTO.Type:
            let items = (try? context.fetch(FetchDescriptor<CardSD>())) ?? []
            items.forEach { context.delete($0) }
        case is SetDTO.Type:
            let items = (try? context.fetch(FetchDescriptor<SetSD>())) ?? []
            items.forEach { context.delete($0) }
        case is DeckDTO.Type:
            let items = (try? context.fetch(FetchDescriptor<DeckSD>())) ?? []
            items.forEach { context.delete($0) }
        case is PersonDTO.Type:
            let items = (try? context.fetch(FetchDescriptor<PersonSD>())) ?? []
            items.forEach { context.delete($0) }
        case is UserCollectionDTO.Type:
            let items = (try? context.fetch(FetchDescriptor<UserCollectionSD>())) ?? []
            items.forEach { context.delete($0) }
        default:
            return
        }
        try saveContext()
    }

    func reset() async throws {
        let cards = (try? context.fetch(FetchDescriptor<CardSD>())) ?? []
        cards.forEach { context.delete($0) }
        let sets = (try? context.fetch(FetchDescriptor<SetSD>())) ?? []
        sets.forEach { context.delete($0) }
        let decks = (try? context.fetch(FetchDescriptor<DeckSD>())) ?? []
        decks.forEach { context.delete($0) }
        let persons = (try? context.fetch(FetchDescriptor<PersonSD>())) ?? []
        persons.forEach { context.delete($0) }
        let collections = (try? context.fetch(FetchDescriptor<UserCollectionSD>())) ?? []
        collections.forEach { context.delete($0) }
        try saveContext()
    }

    // MARK: - DatabaseProtocol: Observe

    func observe<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AsyncStream<[T]> {
        AsyncStream { [weak self] continuation in
            guard let self else {
                continuation.finish()
                return
            }

            Task { @MainActor [weak self] in
                guard let self else { return }
                let initial = await fetch(model, predicate: predicate, sorted: sorted)
                continuation.yield(initial)
            }

            let observer = NotificationCenter.default.addObserver(
                forName: Self.didChangeNotification,
                object: self,
                queue: .main
            ) { [weak self] _ in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    let items = await fetch(model, predicate: predicate, sorted: sorted)
                    continuation.yield(items)
                }
            }

            continuation.onTermination = { _ in
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }

    // MARK: - Private: Fetch Helpers

    private func fetchCards(sorted: Sorted?) -> [CardDTO] {
        var descriptor = FetchDescriptor<CardSD>()
        if let sorted {
            descriptor.sortBy = sortDescriptors(for: CardSD.self, sorted: sorted)
        }
        return ((try? context.fetch(descriptor)) ?? []).map { cardDTO(from: $0) }
    }

    private func fetchSets(sorted: Sorted?) -> [SetDTO] {
        var descriptor = FetchDescriptor<SetSD>()
        if let sorted {
            descriptor.sortBy = sortDescriptors(for: SetSD.self, sorted: sorted)
        }
        return ((try? context.fetch(descriptor)) ?? []).map { setDTO(from: $0) }
    }

    private func fetchDecks(sorted: Sorted?) -> [DeckDTO] {
        var descriptor = FetchDescriptor<DeckSD>()
        if let sorted {
            descriptor.sortBy = sortDescriptors(for: DeckSD.self, sorted: sorted)
        }
        return ((try? context.fetch(descriptor)) ?? []).map { deckDTO(from: $0) }
    }

    private func fetchPersons(sorted: Sorted?) -> [PersonDTO] {
        var descriptor = FetchDescriptor<PersonSD>()
        if let sorted {
            descriptor.sortBy = sortDescriptors(for: PersonSD.self, sorted: sorted)
        }
        return ((try? context.fetch(descriptor)) ?? []).map { personDTO(from: $0) }
    }

    private func fetchUserCollections() -> [UserCollectionDTO] {
        let descriptor = FetchDescriptor<UserCollectionSD>()
        return ((try? context.fetch(descriptor)) ?? []).map { userCollectionDTO(from: $0) }
    }

    // MARK: - Private: Sort Descriptors

    private func sortDescriptors(for _: CardSD.Type, sorted: Sorted) -> [SortDescriptor<CardSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }

    private func sortDescriptors(for _: SetSD.Type, sorted: Sorted) -> [SortDescriptor<SetSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }

    private func sortDescriptors(for _: DeckSD.Type, sorted: Sorted) -> [SortDescriptor<DeckSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }

    private func sortDescriptors(for _: PersonSD.Type, sorted: Sorted) -> [SortDescriptor<PersonSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }

    // MARK: - Private: Find Helpers

    private func findCard(id: String) -> CardSD? {
        let predicate = #Predicate<CardSD> { $0.id == id }
        var descriptor = FetchDescriptor<CardSD>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private func findSet(code: String) -> SetSD? {
        let predicate = #Predicate<SetSD> { $0.code == code }
        var descriptor = FetchDescriptor<SetSD>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private func findDeck(id: String) -> DeckSD? {
        let predicate = #Predicate<DeckSD> { $0.id == id }
        var descriptor = FetchDescriptor<DeckSD>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private func findPerson(id: String) -> PersonSD? {
        let predicate = #Predicate<PersonSD> { $0.id == id }
        var descriptor = FetchDescriptor<PersonSD>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private func findUserCollection(id: String) -> UserCollectionSD? {
        let predicate = #Predicate<UserCollectionSD> { $0.id == id }
        var descriptor = FetchDescriptor<UserCollectionSD>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    // MARK: - Private: Find or Create

    private func findOrCreateCard(id: String) -> CardSD {
        if let existing = findCard(id: id) { return existing }
        let card = CardSD(id: id)
        context.insert(card)
        return card
    }

    private func findOrCreateSet(code: String) -> SetSD {
        if let existing = findSet(code: code) { return existing }
        let set = SetSD(code: code)
        context.insert(set)
        return set
    }

    private func findOrCreateDeck(id: String) -> DeckSD {
        if let existing = findDeck(id: id) { return existing }
        let deck = DeckSD(id: id)
        context.insert(deck)
        return deck
    }

    private func findOrCreatePerson(id: String) -> PersonSD {
        if let existing = findPerson(id: id) { return existing }
        let person = PersonSD(id: id)
        context.insert(person)
        return person
    }

    private func findOrCreateUserCollection(id: String) -> UserCollectionSD {
        if let existing = findUserCollection(id: id) { return existing }
        let collection = UserCollectionSD(id: id)
        context.insert(collection)
        return collection
    }

    // MARK: - Private: Upsert

    private func upsert(_ object: Storable) throws {
        switch object {
        case let card as CardDTO:
            let stored = findOrCreateCard(id: card.id)
            populate(card: stored, from: card)
        case let set as SetDTO:
            let stored = findOrCreateSet(code: set.code)
            populate(set: stored, from: set)
        case let deck as DeckDTO:
            let stored = findOrCreateDeck(id: deck.id)
            populate(deck: stored, from: deck)
        case let person as PersonDTO:
            let stored = findOrCreatePerson(id: person.id)
            populate(person: stored, from: person)
        case let collection as UserCollectionDTO:
            let stored = findOrCreateUserCollection(id: collection.id)
            populate(collection: stored, from: collection)
        default:
            throw SwiftDataManagerError.unsupportedType(String(describing: type(of: object)))
        }
    }

    // MARK: - Private: Populate SD from DTO

    private func populate(card: CardSD, from dto: CardDTO) {
        card.code = dto.code
        card.name = dto.name
        card.subtitle = dto.subtitle
        card.setCode = dto.setCode
        card.setName = dto.setName
        card.typeCode = dto.typeCode
        card.typeName = dto.typeName
        card.factionCode = dto.factionCode
        card.factionName = dto.factionName
        card.affiliationCode = dto.affiliationCode
        card.affiliationName = dto.affiliationName
        card.rarityCode = dto.rarityCode
        card.rarityName = dto.rarityName
        card.position = dto.position
        card.ttscardid = dto.ttscardid
        card.cost = dto.cost
        card.health = dto.health
        card.points = dto.points
        card.text = dto.text
        card.deckLimit = dto.deckLimit
        card.flavor = dto.flavor
        card.illustrator = dto.illustrator
        card.isUnique = dto.isUnique
        card.hasDie = dto.hasDie
        card.externalUrl = dto.externalUrl
        card.imageUrl = dto.imageUrl
        card.label = dto.label
        card.cp = dto.cp
        card.quantity = dto.quantity
        card.isElite = dto.isElite
        card.dieFaces = dto.dieFaces
    }

    private func populate(set: SetSD, from dto: SetDTO) {
        set.id = dto.id
        set.name = dto.name
    }

    private func populate(deck: DeckSD, from dto: DeckDTO) {
        deck.name = dto.name
        deck.list = dto.list.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
    }

    private func populate(person: PersonSD, from dto: PersonDTO) {
        person.name = dto.name
        person.lastName = dto.lastName
        person.lentMe = dto.lentMe.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
        person.borrowed = dto.borrowed.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
    }

    private func populate(collection: UserCollectionSD, from dto: UserCollectionDTO) {
        collection.myCollection = dto.myCollection.map { cardDTO in
            let stored = findOrCreateCard(id: cardDTO.id)
            populate(card: stored, from: cardDTO)
            return stored
        }
    }

    // MARK: - Private: Map SD → DTO

    private func cardDTO(from stored: CardSD) -> CardDTO {
        let dto = CardDTO()
        dto.id = stored.id
        dto.code = stored.code
        dto.name = stored.name
        dto.subtitle = stored.subtitle
        dto.setCode = stored.setCode
        dto.setName = stored.setName
        dto.typeCode = stored.typeCode
        dto.typeName = stored.typeName
        dto.factionCode = stored.factionCode
        dto.factionName = stored.factionName
        dto.affiliationCode = stored.affiliationCode
        dto.affiliationName = stored.affiliationName
        dto.rarityCode = stored.rarityCode
        dto.rarityName = stored.rarityName
        dto.position = stored.position
        dto.ttscardid = stored.ttscardid
        dto.cost = stored.cost
        dto.health = stored.health
        dto.points = stored.points
        dto.text = stored.text
        dto.deckLimit = stored.deckLimit
        dto.flavor = stored.flavor
        dto.illustrator = stored.illustrator
        dto.isUnique = stored.isUnique
        dto.hasDie = stored.hasDie
        dto.externalUrl = stored.externalUrl
        dto.imageUrl = stored.imageUrl
        dto.label = stored.label
        dto.cp = stored.cp
        dto.quantity = stored.quantity
        dto.isElite = stored.isElite
        dto.dieFaces = stored.dieFaces
        return dto
    }

    private func setDTO(from stored: SetSD) -> SetDTO {
        let dto = SetDTO()
        dto.id = stored.id
        dto.name = stored.name
        dto.code = stored.code
        return dto
    }

    private func deckDTO(from stored: DeckSD) -> DeckDTO {
        let dto = DeckDTO()
        dto.id = stored.id
        dto.name = stored.name
        dto.list = stored.list.map { cardDTO(from: $0) }
        return dto
    }

    private func personDTO(from stored: PersonSD) -> PersonDTO {
        let dto = PersonDTO()
        dto.id = stored.id
        dto.name = stored.name
        dto.lastName = stored.lastName
        dto.lentMe = stored.lentMe.map { cardDTO(from: $0) }
        dto.borrowed = stored.borrowed.map { cardDTO(from: $0) }
        return dto
    }

    private func userCollectionDTO(from stored: UserCollectionSD) -> UserCollectionDTO {
        let dto = UserCollectionDTO()
        dto.id = stored.id
        dto.myCollection = stored.myCollection.map { cardDTO(from: $0) }
        return dto
    }

    // MARK: - Private: Save

    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
            notifyChange()
        } catch {
            throw SwiftDataManagerError.writeOperationFailed(underlying: error)
        }
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
    }
}
