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
final class SwiftDataManager: @MainActor DatabaseProtocol {

    private let container: ModelContainer

    private var context: ModelContext {
        container.mainContext
    }

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
            return fetchCards(sorted: sorted) as? [T] ?? []
        case is SetDTO.Type:
            return fetchSets(sorted: sorted) as? [T] ?? []
        case is DeckDTO.Type:
            return fetchDecks(sorted: sorted) as? [T] ?? []
        case is PersonDTO.Type:
            return fetchPersons(sorted: sorted) as? [T] ?? []
        case is UserCollectionDTO.Type:
            return fetchUserCollections() as? [T] ?? []
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
        deleteStoredModel(for: object)
        try saveContext()
    }

    func deleteAll(_ model: (some Storable).Type) async throws {
        switch model {
        case is CardDTO.Type:
            try context.delete(model: CardSD.self)
        case is SetDTO.Type:
            try context.delete(model: SetSD.self)
        case is DeckDTO.Type:
            try context.delete(model: DeckSD.self)
        case is PersonDTO.Type:
            try context.delete(model: PersonSD.self)
        case is UserCollectionDTO.Type:
            try context.delete(model: UserCollectionSD.self)
        default:
            return
        }
        try saveContext()
    }

    func reset() async throws {
        try context.delete(model: CardSD.self)
        try context.delete(model: SetSD.self)
        try context.delete(model: DeckSD.self)
        try context.delete(model: PersonSD.self)
        try context.delete(model: UserCollectionSD.self)
        try saveContext()
    }

    // MARK: - DatabaseProtocol: Observe

    @discardableResult
    func observe<T: Storable>(
        _ model: T.Type,
        predicate: NSPredicate?,
        sorted: Sorted?,
        onChange: @escaping @MainActor ([T]) -> Void
    ) -> DatabaseObservation {
        let observation = SwiftDataObservation(
            database: self,
            model: model,
            predicate: predicate,
            sorted: sorted,
            notification: Self.didChangeNotification,
            onChange: onChange
        )
        observation.start()
        return observation
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

    // MARK: - Private: Delete helper

    private func deleteStoredModel(for object: Storable) {
        switch object {
        case let card as CardDTO:
            deleteIfFound(findCard(id: card.id))
        case let set as SetDTO:
            deleteIfFound(findSet(code: set.code))
        case let deck as DeckDTO:
            deleteIfFound(findDeck(id: deck.id))
        case let person as PersonDTO:
            deleteIfFound(findPerson(id: person.id))
        case let collection as UserCollectionDTO:
            deleteIfFound(findUserCollection(id: collection.id))
        default:
            break
        }
    }

    private func deleteIfFound(_ model: (some PersistentModel)?) {
        if let model { context.delete(model) }
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

@MainActor
private final class SwiftDataObservation<T: Storable>: DatabaseObservation {

    private weak var database: SwiftDataManager?
    private let model: T.Type
    private let predicate: NSPredicate?
    private let sorted: Sorted?
    private let notification: Notification.Name
    private let onChange: @MainActor ([T]) -> Void

    private var observer: NSObjectProtocol?
    private var fetchTask: Task<Void, Never>?

    init(
        database: SwiftDataManager,
        model: T.Type,
        predicate: NSPredicate?,
        sorted: Sorted?,
        notification: Notification.Name,
        onChange: @escaping @MainActor ([T]) -> Void
    ) {
        self.database = database
        self.model = model
        self.predicate = predicate
        self.sorted = sorted
        self.notification = notification
        self.onChange = onChange
    }

    func start() {
        observer = NotificationCenter.default.addObserver(
            forName: notification,
            object: database,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.fetchCurrentValue()
            }
        }
        fetchCurrentValue()
    }

    func cancel() {
        fetchTask?.cancel()
        fetchTask = nil

        if let observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }

    isolated deinit {
        cancel()
    }

    private func fetchCurrentValue() {
        fetchTask?.cancel()
        fetchTask = Task { @MainActor [weak self] in
            guard let self, let database else { return }
            let items = await database.fetch(model, predicate: predicate, sorted: sorted)
            guard !Task.isCancelled else { return }
            onChange(items)
        }
    }
}

// MARK: - Fetch Helpers

private extension SwiftDataManager {

    func fetchCards(sorted: Sorted?) -> [CardDTO] {
        var descriptor = FetchDescriptor<CardSD>()
        if let sorted { descriptor.sortBy = sortDescriptors(for: CardSD.self, sorted: sorted) }
        return ((try? context.fetch(descriptor)) ?? []).map { cardDTO(from: $0) }
    }

    func fetchSets(sorted: Sorted?) -> [SetDTO] {
        var descriptor = FetchDescriptor<SetSD>()
        if let sorted { descriptor.sortBy = sortDescriptors(for: SetSD.self, sorted: sorted) }
        return ((try? context.fetch(descriptor)) ?? []).map { setDTO(from: $0) }
    }

    func fetchDecks(sorted: Sorted?) -> [DeckDTO] {
        var descriptor = FetchDescriptor<DeckSD>()
        if let sorted { descriptor.sortBy = sortDescriptors(for: DeckSD.self, sorted: sorted) }
        return ((try? context.fetch(descriptor)) ?? []).map { deckDTO(from: $0) }
    }

    func fetchPersons(sorted: Sorted?) -> [PersonDTO] {
        var descriptor = FetchDescriptor<PersonSD>()
        if let sorted { descriptor.sortBy = sortDescriptors(for: PersonSD.self, sorted: sorted) }
        return ((try? context.fetch(descriptor)) ?? []).map { personDTO(from: $0) }
    }

    func fetchUserCollections() -> [UserCollectionDTO] {
        return ((try? context.fetch(FetchDescriptor<UserCollectionSD>())) ?? []).map { userCollectionDTO(from: $0) }
    }

    func sortDescriptors(for _: CardSD.Type, sorted: Sorted) -> [SortDescriptor<CardSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }

    func sortDescriptors(for _: SetSD.Type, sorted: Sorted) -> [SortDescriptor<SetSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }

    func sortDescriptors(for _: DeckSD.Type, sorted: Sorted) -> [SortDescriptor<DeckSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }

    func sortDescriptors(for _: PersonSD.Type, sorted: Sorted) -> [SortDescriptor<PersonSD>] {
        guard sorted.key == "name" else { return [] }
        return [SortDescriptor(\.name, order: sorted.ascending ? .forward : .reverse)]
    }
}

// MARK: - Find & FindOrCreate Helpers

extension SwiftDataManager {

    func findCard(id: String) -> CardSD? {
        var descriptor = FetchDescriptor<CardSD>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func findSet(code: String) -> SetSD? {
        var descriptor = FetchDescriptor<SetSD>(predicate: #Predicate { $0.code == code })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func findDeck(id: String) -> DeckSD? {
        var descriptor = FetchDescriptor<DeckSD>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func findPerson(id: String) -> PersonSD? {
        var descriptor = FetchDescriptor<PersonSD>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func findUserCollection(id: String) -> UserCollectionSD? {
        var descriptor = FetchDescriptor<UserCollectionSD>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func findOrCreateCard(id: String) -> CardSD {
        if let existing = findCard(id: id) { return existing }
        let card = CardSD(id: id)
        context.insert(card)
        return card
    }

    func findOrCreateSet(code: String) -> SetSD {
        if let existing = findSet(code: code) { return existing }
        let set = SetSD(code: code)
        context.insert(set)
        return set
    }

    func findOrCreateDeck(id: String) -> DeckSD {
        if let existing = findDeck(id: id) { return existing }
        let deck = DeckSD(id: id)
        context.insert(deck)
        return deck
    }

    func findOrCreatePerson(id: String) -> PersonSD {
        if let existing = findPerson(id: id) { return existing }
        let person = PersonSD(id: id)
        context.insert(person)
        return person
    }

    func findOrCreateUserCollection(id: String) -> UserCollectionSD {
        if let existing = findUserCollection(id: id) { return existing }
        let collection = UserCollectionSD(id: id)
        context.insert(collection)
        return collection
    }
}
