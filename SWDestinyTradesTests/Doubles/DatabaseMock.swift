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

    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) async -> [T] {
        lock.lock()
        defer { lock.unlock() }

        let key = String(describing: model)
        let objects = storage[key] ?? []
        var result = objects.compactMap { $0 as? T }

        print("🔍 DatabaseMock[\(ObjectIdentifier(self))].fetch: Fetching \(key), found \(result.count) objects")

        if let predicate {
            result = result.filter { object in
                predicate.evaluate(with: object)
            }
        }

        if let sorted {
            result = result.sorted { obj1, obj2 in
                let value1 = (obj1 as AnyObject).value(forKey: sorted.key)
                let value2 = (obj2 as AnyObject).value(forKey: sorted.key)

                if let str1 = value1 as? String, let str2 = value2 as? String {
                    return sorted.ascending ? str1 < str2 : str1 > str2
                }
                return sorted.ascending
            }
        }

        return result
    }

    func fetchByKey<T: Storable>(_ model: T.Type, key: Any) async -> T? {
        let objects = await fetch(model, predicate: nil, sorted: nil)
        return objects.first { object in
            if let codable = object as? AnyObject,
               let primaryKey = codable.value(forKey: "id") as? String,
               let keyString = key as? String {
                return primaryKey == keyString
            }
            return false
        }
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

        if let codable = object as? AnyObject,
           let id = codable.value(forKey: "id") as? String {
            if let index = objects.firstIndex(where: { existing in
                if let existingCodable = existing as? AnyObject,
                   let existingId = existingCodable.value(forKey: "id") as? String {
                    return existingId == id
                }
                return false
            }) {
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

    func update(_ block: @escaping () throws -> Void) async throws {
        try block()
    }

    func delete(object: Storable) async throws {
        lock.lock()
        defer { lock.unlock() }

        let key = String(describing: type(of: object))
        var objects = storage[key] ?? []

        if let codable = object as? AnyObject,
           let id = codable.value(forKey: "id") as? String {
            objects.removeAll { existing in
                if let existingCodable = existing as? AnyObject,
                   let existingId = existingCodable.value(forKey: "id") as? String {
                    return existingId == id
                }
                return false
            }
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
}

enum DatabaseError: Error {
    case invalidObject
}
