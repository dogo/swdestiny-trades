//
//  DatabaseMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 16/02/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class DatabaseMock: DatabaseProtocol, @unchecked Sendable {

    typealias AnyContinuation = AsyncStream<[Any]>.Continuation

    private var storage: [String: [Any]] = [:]
    private var observerContinuations: [String: [AnyContinuation]] = [:]
    private let lock = NSLock()

    func fetch<T: Storable>(_ model: T.Type, predicate _: NSPredicate?, sorted: Sorted?) async -> [T] {
        lock.lock()
        defer { lock.unlock() }

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
        lock.lock()
        defer { lock.unlock() }

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
        lock.lock()
        defer { lock.unlock() }

        let key = String(describing: type(of: object))
        var objects = storage[key] ?? []

        if let id = primaryKey(of: object) {
            objects.removeAll { ($0 as? Storable).flatMap { primaryKey(of: $0) } == id }
        }

        storage[key] = objects
        notifyObservers(for: key)
    }

    func deleteAll(_ model: (some Storable).Type) async throws {
        lock.lock()
        defer { lock.unlock() }

        let key = String(describing: model)
        storage[key] = []
        notifyObservers(for: key)
    }

    func reset() async throws {
        lock.lock()
        defer { lock.unlock() }

        storage.removeAll()
        for (_, continuations) in observerContinuations {
            for continuation in continuations {
                continuation.finish()
            }
        }
        observerContinuations.removeAll()
    }

    func observe<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AsyncStream<[T]> {
        let key = String(describing: model)

        return AsyncStream { continuation in
            lock.lock()
            var continuations = observerContinuations[key] ?? []
            continuations.append(continuation as! AnyContinuation)
            observerContinuations[key] = continuations
            lock.unlock()

            Task {
                let objects = await self.fetch(model, predicate: predicate, sorted: sorted)
                continuation.yield(objects)
            }

            continuation.onTermination = { @Sendable _ in
                Task {
                    self.lock.lock()
                    self.observerContinuations[key]?.removeAll { $0 as AnyObject === continuation as AnyObject }
                    self.lock.unlock()
                }
            }
        }
    }

    private func notifyObservers(for key: String) {
        guard let continuations = observerContinuations[key] else { return }

        Task {
            self.lock.lock()
            let objects = self.storage[key] ?? []
            self.lock.unlock()

            for continuation in continuations {
                continuation.yield(objects)
            }
        }
    }

    // MARK: - Private: Pattern matching helpers

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
