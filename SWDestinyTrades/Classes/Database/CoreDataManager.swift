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
final class CoreDataManager: @MainActor DatabaseProtocol {

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
        guard let mo = findMO(for: object) else { return }
        context.delete(mo)
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
        let (entityName, keyName, keyValue): (String, String, String)

        switch object {
        case let card as CardDTO:
            (entityName, keyName, keyValue) = ("CardMO", "id", card.id)
        case let set as SetDTO:
            (entityName, keyName, keyValue) = ("SetMO", "code", set.code)
        case let deck as DeckDTO:
            (entityName, keyName, keyValue) = ("DeckMO", "id", deck.id)
        case let person as PersonDTO:
            (entityName, keyName, keyValue) = ("PersonMO", "id", person.id)
        case let collection as UserCollectionDTO:
            (entityName, keyName, keyValue) = ("UserCollectionMO", "id", collection.id)
        default:
            return nil
        }

        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", keyName, keyValue)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    // MARK: - Private: Upsert

    private func upsert(_ object: Storable) throws {
        switch object {
        case let card as CardDTO:
            let mo = findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            populate(cardMO: mo, from: card)
        case let set as SetDTO:
            let mo = findOrCreate(entityName: "SetMO", keyName: "code", keyValue: set.code)
            populate(setMO: mo, from: set)
        case let deck as DeckDTO:
            let mo = findOrCreate(entityName: "DeckMO", keyName: "id", keyValue: deck.id)
            populate(deckMO: mo, from: deck)
        case let person as PersonDTO:
            let mo = findOrCreate(entityName: "PersonMO", keyName: "id", keyValue: person.id)
            populate(personMO: mo, from: person)
        case let collection as UserCollectionDTO:
            let mo = findOrCreate(entityName: "UserCollectionMO", keyName: "id", keyValue: collection.id)
            populate(collectionMO: mo, from: collection)
        default:
            throw CoreDataManagerError.unsupportedType(String(describing: type(of: object)))
        }
    }

    // MARK: - Private: Populate MO from DTO

    private func populate(cardMO mo: NSManagedObject, from card: CardDTO) {
        mo.setValue(card.id, forKey: "id")
        mo.setValue(card.code, forKey: "code")
        mo.setValue(card.name, forKey: "name")
        mo.setValue(card.subtitle, forKey: "subtitle")
        mo.setValue(card.setCode, forKey: "setCode")
        mo.setValue(card.setName, forKey: "setName")
        mo.setValue(card.typeCode, forKey: "typeCode")
        mo.setValue(card.typeName, forKey: "typeName")
        mo.setValue(card.factionCode, forKey: "factionCode")
        mo.setValue(card.factionName, forKey: "factionName")
        mo.setValue(card.affiliationCode, forKey: "affiliationCode")
        mo.setValue(card.affiliationName, forKey: "affiliationName")
        mo.setValue(card.rarityCode, forKey: "rarityCode")
        mo.setValue(card.rarityName, forKey: "rarityName")
        mo.setValue(Int32(card.position), forKey: "position")
        mo.setValue(card.ttscardid, forKey: "ttscardid")
        mo.setValue(Int32(card.cost), forKey: "cost")
        mo.setValue(Int32(card.health), forKey: "health")
        mo.setValue(card.points, forKey: "points")
        mo.setValue(card.text, forKey: "text")
        mo.setValue(Int32(card.deckLimit), forKey: "deckLimit")
        mo.setValue(card.flavor, forKey: "flavor")
        mo.setValue(card.illustrator, forKey: "illustrator")
        mo.setValue(card.isUnique, forKey: "isUnique")
        mo.setValue(card.hasDie, forKey: "hasDie")
        mo.setValue(card.externalUrl, forKey: "externalUrl")
        mo.setValue(card.imageUrl, forKey: "imageUrl")
        mo.setValue(card.label, forKey: "label")
        mo.setValue(Int32(card.cp), forKey: "cp")
        mo.setValue(Int32(card.quantity), forKey: "quantity")
        mo.setValue(card.isElite, forKey: "isElite")
        mo.setValue(card.dieFaces as NSArray, forKey: "dieFaces")
    }

    private func populate(setMO mo: NSManagedObject, from set: SetDTO) {
        mo.setValue(set.id, forKey: "id")
        mo.setValue(set.name, forKey: "name")
        mo.setValue(set.code, forKey: "code")
    }

    private func populate(deckMO mo: NSManagedObject, from deck: DeckDTO) {
        mo.setValue(deck.id, forKey: "id")
        mo.setValue(deck.name, forKey: "name")

        let cardMOs = deck.list.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        mo.setValue(NSOrderedSet(array: cardMOs), forKey: "list")
    }

    private func populate(personMO mo: NSManagedObject, from person: PersonDTO) {
        mo.setValue(person.id, forKey: "id")
        mo.setValue(person.name, forKey: "name")
        mo.setValue(person.lastName, forKey: "lastName")

        let lentMOs = person.lentMe.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        mo.setValue(NSOrderedSet(array: lentMOs), forKey: "lentMe")

        let borrowedMOs = person.borrowed.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        mo.setValue(NSOrderedSet(array: borrowedMOs), forKey: "borrowed")
    }

    private func populate(collectionMO mo: NSManagedObject, from collection: UserCollectionDTO) {
        mo.setValue(collection.id, forKey: "id")

        let cardMOs = collection.myCollection.map { card -> NSManagedObject in
            let cardMO = self.findOrCreate(entityName: "CardMO", keyName: "id", keyValue: card.id)
            self.populate(cardMO: cardMO, from: card)
            return cardMO
        }
        mo.setValue(NSOrderedSet(array: cardMOs), forKey: "myCollection")
    }

    // MARK: - Private: Map MO → DTO

    private func toDTO<T: Storable>(_ mo: NSManagedObject, as type: T.Type) -> T? {
        switch type {
        case is CardDTO.Type:
            return cardDTO(from: mo) as? T
        case is SetDTO.Type:
            return setDTO(from: mo) as? T
        case is DeckDTO.Type:
            return deckDTO(from: mo) as? T
        case is PersonDTO.Type:
            return personDTO(from: mo) as? T
        case is UserCollectionDTO.Type:
            return userCollectionDTO(from: mo) as? T
        default:
            return nil
        }
    }

    private func cardDTO(from mo: NSManagedObject) -> CardDTO {
        let dto = CardDTO()
        dto.id = mo.value(forKey: "id") as? String ?? ""
        dto.code = mo.value(forKey: "code") as? String ?? ""
        dto.name = mo.value(forKey: "name") as? String ?? ""
        dto.subtitle = mo.value(forKey: "subtitle") as? String ?? ""
        dto.setCode = mo.value(forKey: "setCode") as? String ?? ""
        dto.setName = mo.value(forKey: "setName") as? String ?? ""
        dto.typeCode = mo.value(forKey: "typeCode") as? String ?? ""
        dto.typeName = mo.value(forKey: "typeName") as? String ?? ""
        dto.factionCode = mo.value(forKey: "factionCode") as? String ?? ""
        dto.factionName = mo.value(forKey: "factionName") as? String ?? ""
        dto.affiliationCode = mo.value(forKey: "affiliationCode") as? String ?? ""
        dto.affiliationName = mo.value(forKey: "affiliationName") as? String ?? ""
        dto.rarityCode = mo.value(forKey: "rarityCode") as? String ?? ""
        dto.rarityName = mo.value(forKey: "rarityName") as? String ?? ""
        dto.position = Int(mo.value(forKey: "position") as? Int32 ?? 0)
        dto.ttscardid = mo.value(forKey: "ttscardid") as? String ?? ""
        dto.cost = Int(mo.value(forKey: "cost") as? Int32 ?? 0)
        dto.health = Int(mo.value(forKey: "health") as? Int32 ?? 0)
        dto.points = mo.value(forKey: "points") as? String ?? ""
        dto.text = mo.value(forKey: "text") as? String ?? ""
        dto.deckLimit = Int(mo.value(forKey: "deckLimit") as? Int32 ?? 0)
        dto.flavor = mo.value(forKey: "flavor") as? String ?? ""
        dto.illustrator = mo.value(forKey: "illustrator") as? String ?? ""
        dto.isUnique = mo.value(forKey: "isUnique") as? Bool ?? false
        dto.hasDie = mo.value(forKey: "hasDie") as? Bool ?? false
        dto.externalUrl = mo.value(forKey: "externalUrl") as? String ?? ""
        dto.imageUrl = mo.value(forKey: "imageUrl") as? String ?? ""
        dto.label = mo.value(forKey: "label") as? String ?? ""
        dto.cp = Int(mo.value(forKey: "cp") as? Int32 ?? 0)
        dto.quantity = Int(mo.value(forKey: "quantity") as? Int32 ?? 1)
        dto.isElite = mo.value(forKey: "isElite") as? Bool ?? false
        dto.dieFaces = (mo.value(forKey: "dieFaces") as? [String]) ?? []
        return dto
    }

    private func setDTO(from mo: NSManagedObject) -> SetDTO {
        let dto = SetDTO()
        dto.id = mo.value(forKey: "id") as? String ?? UUID().uuidString
        dto.name = mo.value(forKey: "name") as? String ?? ""
        dto.code = mo.value(forKey: "code") as? String ?? ""
        return dto
    }

    private func deckDTO(from mo: NSManagedObject) -> DeckDTO {
        let dto = DeckDTO()
        dto.id = mo.value(forKey: "id") as? String ?? ""
        dto.name = mo.value(forKey: "name") as? String ?? ""

        if let orderedSet = mo.value(forKey: "list") as? NSOrderedSet {
            dto.list = orderedSet.array.compactMap { ($0 as? NSManagedObject).map { self.cardDTO(from: $0) } }
        }

        return dto
    }

    private func personDTO(from mo: NSManagedObject) -> PersonDTO {
        let dto = PersonDTO()
        dto.id = mo.value(forKey: "id") as? String ?? ""
        dto.name = mo.value(forKey: "name") as? String ?? ""
        dto.lastName = mo.value(forKey: "lastName") as? String ?? ""

        if let orderedSet = mo.value(forKey: "lentMe") as? NSOrderedSet {
            dto.lentMe = orderedSet.array.compactMap { ($0 as? NSManagedObject).map { self.cardDTO(from: $0) } }
        }

        if let orderedSet = mo.value(forKey: "borrowed") as? NSOrderedSet {
            dto.borrowed = orderedSet.array.compactMap { ($0 as? NSManagedObject).map { self.cardDTO(from: $0) } }
        }

        return dto
    }

    private func userCollectionDTO(from mo: NSManagedObject) -> UserCollectionDTO {
        let dto = UserCollectionDTO()
        dto.id = mo.value(forKey: "id") as? String ?? ""

        if let orderedSet = mo.value(forKey: "myCollection") as? NSOrderedSet {
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
