//
//  DatabaseMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 16/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

@MainActor
final class DatabaseMock: @MainActor DatabaseProtocol, @unchecked Sendable {

    private typealias ObserverCallback = @MainActor @Sendable ([Any]) -> Void

    var stubbedSaveError: Error?

    private var storage: [String: [Any]] = [:]
    private var observerCallbacks: [String: [UUID: ObserverCallback]] = [:]

    func fetch<T: Storable>(_ model: T.Type, predicate _: NSPredicate?, sorted: Sorted?) async -> [T] {
        let key = String(describing: model)
        let objects = storage[key] ?? []
        var result = objects.compactMap { $0 as? T }

        print("🔍 DatabaseMock[\(ObjectIdentifier(self))].fetch: Fetching \(key), found \(result.count) objects")

        if let sorted {
            result = result.sorted { obj1, obj2 in
                let str1 = stringValue(of: obj1, forKey: sorted.key)
                let str2 = stringValue(of: obj2, forKey: sorted.key)
                if let str1, let str2 {
                    return sorted.ascending ? str1 < str2 : str1 > str2
                }
                return sorted.ascending
            }
        }

        return result
    }

    func fetchByKey<T: Storable>(_ model: T.Type, key: Any) async -> T? {
        guard let keyString = key as? String else { return nil }
        let objects = await fetch(model, predicate: nil, sorted: nil)
        return objects.first { primaryKey(of: $0) == keyString }
    }

    func create<T: Storable>(_ model: T.Type, value: Any, update: UpdatePolicy) async throws -> T {
        guard let object = value as? T else {
            throw DatabaseError.invalidObject
        }
        try await save(object: object, update: update)
        return object
    }

    func save(object: Storable, update: UpdatePolicy) async throws {
        if let error = stubbedSaveError { throw error }
        let key = String(describing: type(of: object))
        var objects = storage[key] ?? []

        print("💾 DatabaseMock[\(ObjectIdentifier(self))].save: Saving \(key)")

        if let id = primaryKey(of: object) {
            if let index = objects.firstIndex(where: { ($0 as? Storable).flatMap { primaryKey(of: $0) } == id }) {
                objects[index] = object
                print("  ✏️  Updated \(key) with id \(id)")
            } else {
                objects.append(object)
                print("  ➕ Added \(key) with id \(id)")
            }
        } else {
            objects.append(object)
            print("  ➕ Added \(key) (no id)")
        }

        storage[key] = objects
        print("  📊 Total \(key) count: \(objects.count)")
        notifyObservers(for: key)
    }

    func delete(object: Storable) async throws {
        let key = String(describing: type(of: object))
        var objects = storage[key] ?? []

        if let id = primaryKey(of: object) {
            objects.removeAll { ($0 as? Storable).flatMap { primaryKey(of: $0) } == id }
        }

        storage[key] = objects
        notifyObservers(for: key)
    }

    func deleteAll(_ model: (some Storable).Type) async throws {
        let key = String(describing: model)
        storage[key] = []
        notifyObservers(for: key)
    }

    func reset() async throws {
        storage.removeAll()
        observerCallbacks.removeAll()
    }

    func observe<T: Storable>(_ model: T.Type, predicate _: NSPredicate?, sorted _: Sorted?) -> AsyncStream<[T]> {
        let key = String(describing: model)
        let id = UUID()

        return AsyncStream { continuation in
            Task { @MainActor [weak self] in
                guard let self else { return }
                let callback: ObserverCallback = { items in
                    let typedItems = items.compactMap { $0 as? T }
                    // DTOs are mutable legacy reference types; observe streams are consumed by main-actor view models.
                    nonisolated(unsafe) let emittedItems = typedItems
                    continuation.yield(emittedItems)
                }
                observerCallbacks[key, default: [:]][id] = callback
                let initial = (storage[key] ?? []).compactMap { $0 as? T }
                // DTOs are mutable legacy reference types; observe streams are consumed by main-actor view models.
                nonisolated(unsafe) let emittedInitial = initial
                continuation.yield(emittedInitial)
            }

            continuation.onTermination = { @Sendable _ in
                Task { @MainActor [weak self] in
                    self?.observerCallbacks[key]?.removeValue(forKey: id)
                }
            }
        }
    }

    // MARK: - Private

    private func notifyObservers(for key: String) {
        let items = storage[key] ?? []
        observerCallbacks[key]?.values.forEach { $0(items) }
    }

    private func primaryKey(of object: Storable) -> String? {
        switch object {
        case let card as CardDTO:
            return card.id
        case let set as SetDTO:
            return set.id
        case let deck as DeckDTO:
            return deck.id
        case let person as PersonDTO:
            return person.id
        case let collection as UserCollectionDTO:
            return collection.id
        default:
            return nil
        }
    }

    private func stringValue(of object: Storable, forKey key: String) -> String? {
        switch key {
        case "name":
            switch object {
            case let card as CardDTO:
                return card.name
            case let set as SetDTO:
                return set.name
            case let deck as DeckDTO:
                return deck.name
            case let person as PersonDTO:
                return person.name
            default:
                return nil
            }
        default:
            return nil
        }
    }
}

enum DatabaseError: Error {
    case invalidObject
}
