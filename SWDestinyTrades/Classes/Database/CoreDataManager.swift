//
//  CoreDataManager.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 12/03/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import CoreData
import Foundation

// MARK: - CoreDataManagerError

enum CoreDataManagerError: Error, LocalizedError {
    case initializationFailed(underlying: Error)
    case writeOperationFailed(underlying: Error)
    case unsupportedType(String)

    var errorDescription: String? {
        switch self {
        case let .initializationFailed(error):
            return "Failed to initialize Core Data: \(error.localizedDescription)"
        case let .writeOperationFailed(error):
            return "Write operation failed: \(error.localizedDescription)"
        case let .unsupportedType(type):
            return "Unsupported storable type: \(type)"
        }
    }
}

// MARK: - CoreDataManager

@MainActor
final class CoreDataManager: @MainActor DatabaseProtocol { // swiftlint:disable:this type_body_length

    private let container: NSPersistentContainer

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Factory

    static func create(inMemory: Bool = false) async throws -> CoreDataManager {
        let container = NSPersistentContainer(name: "SWDestinyTrades")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { _, error in
                if let error {
                    continuation.resume(throwing: CoreDataManagerError.initializationFailed(underlying: error))
                } else {
                    continuation.resume()
                }
            }
        }

        #if DEBUG
            if let url = container.persistentStoreDescriptions.first?.url {
                print("CoreData store: \(url.path)")
            }
        #endif

        return CoreDataManager(container: container)
    }

    private init(container: NSPersistentContainer) {
        self.container = container
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - DatabaseProtocol: Fetch

    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) async -> [T] {
        guard let entityName = resolveEntityName(for: model) else { return [] }

        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        if let sorted {
            request.sortDescriptors = [NSSortDescriptor(key: sorted.key, ascending: sorted.ascending)]
        }

        let results = (try? context.fetch(request)) ?? []
        return results.compactMap { self.toDTO($0, as: model) }
    }

    func fetchByKey<T: Storable>(_ model: T.Type, key: Any) async -> T? {
        guard let entityName = resolveEntityName(for: model),
              let keyString = key as? String else { return nil }

        let keyName = resolvePrimaryKeyName(for: model)
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", keyName, keyString)
        request.fetchLimit = 1

        return (try? context.fetch(request))?.first.flatMap { self.toDTO($0, as: model) }
    }

    // MARK: - DatabaseProtocol: Write

    func create<T: Storable>(_ model: T.Type, value: Any, update: UpdatePolicy) async throws -> T {
        guard let dto = value as? T else {
            throw CoreDataManagerError.unsupportedType(String(describing: model))
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
        guard let managedObject = findMO(for: object) else { return }
        context.delete(managedObject)
        try saveContext()
    }

    func deleteAll(_ model: (some Storable).Type) async throws {
        guard let entityName = resolveEntityName(for: model) else { return }

        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let objects = (try? context.fetch(request)) ?? []
        objects.forEach { context.delete($0) }
        try saveContext()
    }

    func reset() async throws {
        let entityNames = ["CardMO", "SetMO", "DeckMO", "PersonMO", "UserCollectionMO"]
        for name in entityNames {
            let request = NSFetchRequest<NSManagedObject>(entityName: name)
            let objects = (try? context.fetch(request)) ?? []
            objects.forEach { context.delete($0) }
        }
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

            let context = context
            let observer = NotificationCenter.default.addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: context,
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

    // MARK: - Private: Entity Metadata

    private func resolveEntityName(for type: (some Storable).Type) -> String? {
        switch type {
        case is CardDTO.Type:
            return "CardMO"
        case is SetDTO.Type:
            return "SetMO"
        case is DeckDTO.Type:
            return "DeckMO"
        case is PersonDTO.Type:
            return "PersonMO"
        case is UserCollectionDTO.Type:
            return "UserCollectionMO"
        default:
            return nil
        }
    }

    private func resolvePrimaryKeyName(for type: (some Storable).Type) -> String {
        type is SetDTO.Type ? "code" : "id"
    }

    // MARK: - Private: Find MO

    private struct EntityKey {
        let entityName: String
        let keyName: String
        let keyValue: String
    }

    private func findOrCreate(entityName: String, keyName: String, keyValue: String) -> NSManagedObject {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", keyName, keyValue)
        request.fetchLimit = 1

        if let existing = try? context.fetch(request).first {
            return existing
        }

        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }

    private func findMO(for object: Storable) -> NSManagedObject? {
        let entityKey: EntityKey

        switch object {
        case let card as CardDTO:
            entityKey = EntityKey(entityName: "CardMO", keyName: "id", keyValue: card.id)
        case let set as SetDTO:
            entityKey = EntityKey(entityName: "SetMO", keyName: "code", keyValue: set.code)
        case let deck as DeckDTO:
            entityKey = EntityKey(entityName: "DeckMO", keyName: "id", keyValue: deck.id)
        case let person as PersonDTO:
            entityKey = EntityKey(entityName: "PersonMO", keyName: "id", keyValue: person.id)
        case let collection as UserCollectionDTO:
            entityKey = EntityKey(entityName: "UserCollectionMO", keyName: "id", keyValue: collection.id)
        default:
            return nil
        }

        let request = NSFetchRequest<NSManagedObject>(entityName: entityKey.entityName)
        request.predicate = NSPredicate(format: "%K == %@", entityKey.keyName, entityKey.keyValue)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    // MARK: - Private: Upsert

    private func upsert(_ object: Storable) throws {
        switch object {
        case let card as CardDTO:
            let managedObject = findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            populate(cardMO: managedObject, from: card)
        case let set as SetDTO:
            let managedObject = findOrCreate(entityName: "SetMO", keyName: "code", keyValue: set.code)
            populate(setMO: managedObject, from: set)
        case let deck as DeckDTO:
            let managedObject = findOrCreate(entityName: "DeckMO", keyName: "id", keyValue: deck.id)
            populate(deckMO: managedObject, from: deck)
        case let person as PersonDTO:
            let managedObject = findOrCreate(entityName: "PersonMO", keyName: "id", keyValue: person.id)
            populate(personMO: managedObject, from: person)
        case let collection as UserCollectionDTO:
            let managedObject = findOrCreate(entityName: "UserCollectionMO", keyName: "id", keyValue: collection.id)
            populate(collectionMO: managedObject, from: collection)
        default:
            throw CoreDataManagerError.unsupportedType(String(describing: type(of: object)))
        }
    }

    // MARK: - Private: Populate MO from DTO

    private func populate(cardMO managedObject: NSManagedObject, from card: CardDTO) {
        managedObject.setValue(card.id, forKey: "id")
        managedObject.setValue(card.code, forKey: "code")
        managedObject.setValue(card.name, forKey: "name")
        managedObject.setValue(card.subtitle, forKey: "subtitle")
        managedObject.setValue(card.setCode, forKey: "setCode")
        managedObject.setValue(card.setName, forKey: "setName")
        managedObject.setValue(card.typeCode, forKey: "typeCode")
        managedObject.setValue(card.typeName, forKey: "typeName")
        managedObject.setValue(card.factionCode, forKey: "factionCode")
        managedObject.setValue(card.factionName, forKey: "factionName")
        managedObject.setValue(card.affiliationCode, forKey: "affiliationCode")
        managedObject.setValue(card.affiliationName, forKey: "affiliationName")
        managedObject.setValue(card.rarityCode, forKey: "rarityCode")
        managedObject.setValue(card.rarityName, forKey: "rarityName")
        managedObject.setValue(Int32(card.position), forKey: "position")
        managedObject.setValue(card.ttscardid, forKey: "ttscardid")
        managedObject.setValue(Int32(card.cost), forKey: "cost")
        managedObject.setValue(Int32(card.health), forKey: "health")
        managedObject.setValue(card.points, forKey: "points")
        managedObject.setValue(card.text, forKey: "text")
        managedObject.setValue(Int32(card.deckLimit), forKey: "deckLimit")
        managedObject.setValue(card.flavor, forKey: "flavor")
        managedObject.setValue(card.illustrator, forKey: "illustrator")
        managedObject.setValue(card.isUnique, forKey: "isUnique")
        managedObject.setValue(card.hasDie, forKey: "hasDie")
        managedObject.setValue(card.externalUrl, forKey: "externalUrl")
        managedObject.setValue(card.imageUrl, forKey: "imageUrl")
        managedObject.setValue(card.label, forKey: "label")
        managedObject.setValue(Int32(card.cp), forKey: "cp")
        managedObject.setValue(Int32(card.quantity), forKey: "quantity")
        managedObject.setValue(card.isElite, forKey: "isElite")
        managedObject.setValue(card.dieFaces as NSArray, forKey: "dieFaces")
    }

    private func populate(setMO managedObject: NSManagedObject, from set: SetDTO) {
        managedObject.setValue(set.id, forKey: "id")
        managedObject.setValue(set.name, forKey: "name")
        managedObject.setValue(set.code, forKey: "code")
    }

    private func populate(deckMO managedObject: NSManagedObject, from deck: DeckDTO) {
        managedObject.setValue(deck.id, forKey: "id")
        managedObject.setValue(deck.name, forKey: "name")

        let cardMOs = deck.list.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        managedObject.setValue(NSOrderedSet(array: cardMOs), forKey: "list")
    }

    private func populate(personMO managedObject: NSManagedObject, from person: PersonDTO) {
        managedObject.setValue(person.id, forKey: "id")
        managedObject.setValue(person.name, forKey: "name")
        managedObject.setValue(person.lastName, forKey: "lastName")

        let lentMOs = person.lentMe.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        managedObject.setValue(NSOrderedSet(array: lentMOs), forKey: "lentMe")

        let borrowedMOs = person.borrowed.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        managedObject.setValue(NSOrderedSet(array: borrowedMOs), forKey: "borrowed")
    }

    private func populate(collectionMO managedObject: NSManagedObject, from collection: UserCollectionDTO) {
        managedObject.setValue(collection.id, forKey: "id")

        let cardMOs = collection.myCollection.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        managedObject.setValue(NSOrderedSet(array: cardMOs), forKey: "myCollection")
    }

    // MARK: - Private: Map MO → DTO

    private func toDTO<T: Storable>(_ managedObject: NSManagedObject, as type: T.Type) -> T? {
        switch type {
        case is CardDTO.Type:
            return cardDTO(from: managedObject) as? T
        case is SetDTO.Type:
            return setDTO(from: managedObject) as? T
        case is DeckDTO.Type:
            return deckDTO(from: managedObject) as? T
        case is PersonDTO.Type:
            return personDTO(from: managedObject) as? T
        case is UserCollectionDTO.Type:
            return userCollectionDTO(from: managedObject) as? T
        default:
            return nil
        }
    }

    private func cardDTO(from managedObject: NSManagedObject) -> CardDTO {
        let dto = CardDTO()
        dto.id = managedObject.value(forKey: "id") as? String ?? ""
        dto.code = managedObject.value(forKey: "code") as? String ?? ""
        dto.name = managedObject.value(forKey: "name") as? String ?? ""
        dto.subtitle = managedObject.value(forKey: "subtitle") as? String ?? ""
        dto.setCode = managedObject.value(forKey: "setCode") as? String ?? ""
        dto.setName = managedObject.value(forKey: "setName") as? String ?? ""
        dto.typeCode = managedObject.value(forKey: "typeCode") as? String ?? ""
        dto.typeName = managedObject.value(forKey: "typeName") as? String ?? ""
        dto.factionCode = managedObject.value(forKey: "factionCode") as? String ?? ""
        dto.factionName = managedObject.value(forKey: "factionName") as? String ?? ""
        dto.affiliationCode = managedObject.value(forKey: "affiliationCode") as? String ?? ""
        dto.affiliationName = managedObject.value(forKey: "affiliationName") as? String ?? ""
        dto.rarityCode = managedObject.value(forKey: "rarityCode") as? String ?? ""
        dto.rarityName = managedObject.value(forKey: "rarityName") as? String ?? ""
        dto.position = Int(managedObject.value(forKey: "position") as? Int32 ?? 0)
        dto.ttscardid = managedObject.value(forKey: "ttscardid") as? String ?? ""
        dto.cost = Int(managedObject.value(forKey: "cost") as? Int32 ?? 0)
        dto.health = Int(managedObject.value(forKey: "health") as? Int32 ?? 0)
        dto.points = managedObject.value(forKey: "points") as? String ?? ""
        dto.text = managedObject.value(forKey: "text") as? String ?? ""
        dto.deckLimit = Int(managedObject.value(forKey: "deckLimit") as? Int32 ?? 0)
        dto.flavor = managedObject.value(forKey: "flavor") as? String ?? ""
        dto.illustrator = managedObject.value(forKey: "illustrator") as? String ?? ""
        dto.isUnique = managedObject.value(forKey: "isUnique") as? Bool ?? false
        dto.hasDie = managedObject.value(forKey: "hasDie") as? Bool ?? false
        dto.externalUrl = managedObject.value(forKey: "externalUrl") as? String ?? ""
        dto.imageUrl = managedObject.value(forKey: "imageUrl") as? String ?? ""
        dto.label = managedObject.value(forKey: "label") as? String ?? ""
        dto.cp = Int(managedObject.value(forKey: "cp") as? Int32 ?? 0)
        dto.quantity = Int(managedObject.value(forKey: "quantity") as? Int32 ?? 1)
        dto.isElite = managedObject.value(forKey: "isElite") as? Bool ?? false
        dto.dieFaces = (managedObject.value(forKey: "dieFaces") as? [String]) ?? []
        return dto
    }

    private func setDTO(from managedObject: NSManagedObject) -> SetDTO {
        let dto = SetDTO()
        dto.id = managedObject.value(forKey: "id") as? String ?? UUID().uuidString
        dto.name = managedObject.value(forKey: "name") as? String ?? ""
        dto.code = managedObject.value(forKey: "code") as? String ?? ""
        return dto
    }

    private func deckDTO(from managedObject: NSManagedObject) -> DeckDTO {
        let dto = DeckDTO()
        dto.id = managedObject.value(forKey: "id") as? String ?? ""
        dto.name = managedObject.value(forKey: "name") as? String ?? ""

        if let orderedSet = managedObject.value(forKey: "list") as? NSOrderedSet {
            dto.list = orderedSet.array.compactMap { ($0 as? NSManagedObject).map { self.cardDTO(from: $0) } }
        }

        return dto
    }

    private func personDTO(from managedObject: NSManagedObject) -> PersonDTO {
        let dto = PersonDTO()
        dto.id = managedObject.value(forKey: "id") as? String ?? ""
        dto.name = managedObject.value(forKey: "name") as? String ?? ""
        dto.lastName = managedObject.value(forKey: "lastName") as? String ?? ""

        if let orderedSet = managedObject.value(forKey: "lentMe") as? NSOrderedSet {
            dto.lentMe = orderedSet.array.compactMap { ($0 as? NSManagedObject).map { self.cardDTO(from: $0) } }
        }

        if let orderedSet = managedObject.value(forKey: "borrowed") as? NSOrderedSet {
            dto.borrowed = orderedSet.array.compactMap { ($0 as? NSManagedObject).map { self.cardDTO(from: $0) } }
        }

        return dto
    }

    private func userCollectionDTO(from managedObject: NSManagedObject) -> UserCollectionDTO {
        let dto = UserCollectionDTO()
        dto.id = managedObject.value(forKey: "id") as? String ?? ""

        if let orderedSet = managedObject.value(forKey: "myCollection") as? NSOrderedSet {
            dto.myCollection = orderedSet.array.compactMap { ($0 as? NSManagedObject).map { self.cardDTO(from: $0) } }
        }

        return dto
    }

    // MARK: - Private: Save Context

    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            throw CoreDataManagerError.writeOperationFailed(underlying: error)
        }
    }
}
