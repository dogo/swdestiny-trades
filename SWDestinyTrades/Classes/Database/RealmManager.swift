//
//  RealmManager.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 17/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - RealmDatabaseError

/// Errors that can occur during Realm database operations
enum RealmDatabaseError: Error {
    case invalidMemory(identifier: String?)
    case objectCouldNotBeParsed
}

// MARK: - ConfigurationType

/// Configuration types for Realm database
enum ConfigurationType {
    case basic(url: String?)
    case inMemory(identifier: String?)

    var associated: String? {
        switch self {
        case let .basic(url):
            return url
        case let .inMemory(identifier):
            return identifier
        }
    }
}

// MARK: - RealmManagerError

/// Errors that can occur during RealmManager operations
enum RealmManagerError: Error, LocalizedError {
    case initializationFailed(underlying: Error)
    case writeOperationFailed(underlying: Error)
    case objectNotFound(type: String, key: Any)
    case invalidConfiguration

    var errorDescription: String? {
        switch self {
        case let .initializationFailed(error):
            return "Failed to initialize Realm: \(error.localizedDescription)"
        case let .writeOperationFailed(error):
            return "Write operation failed: \(error.localizedDescription)"
        case let .objectNotFound(type, key):
            return "Object of type \(type) with key \(key) not found"
        case .invalidConfiguration:
            return "Invalid Realm configuration"
        }
    }
}

@MainActor
final class RealmManager: @MainActor DatabaseProtocol {
    private let realm: Realm

    private static let schemaVersion: UInt64 = 1

    // MARK: - Initialization

    /// This is the preferred way to create a RealmManager instance
    /// - Parameter configuration: The configuration type (basic or inMemory)
    /// - Returns: A new RealmManager instance
    /// - Throws: RealmDatabaseError if initialization fails
    static func create(configuration: ConfigurationType = .basic(url: nil)) async throws -> RealmManager {
        var rmConfig = Realm.Configuration()

        let resolvedConfiguration = RealmManager.realmConfiguration(configuration)

        switch resolvedConfiguration {
        case .basic:
            rmConfig = Realm.Configuration.defaultConfiguration
            if let url = resolvedConfiguration.associated {
                rmConfig.fileURL = URL(fileURLWithPath: url)
            }
        case .inMemory:
            rmConfig = Realm.Configuration()
            if let identifier = resolvedConfiguration.associated {
                rmConfig.inMemoryIdentifier = identifier
            } else {
                throw RealmDatabaseError.invalidMemory(identifier: resolvedConfiguration.associated)
            }
        }

        rmConfig.schemaVersion = Self.schemaVersion

        // Use async Realm.open() for better actor isolation
        let realm = try await Realm(configuration: rmConfig, actor: MainActor.shared)
        print("Realm file: \(realm.configuration.fileURL?.path ?? "in-memory")")
        return RealmManager(realm: realm)
    }

    private static func realmConfiguration(_ configuration: ConfigurationType) -> ConfigurationType {
        let resolvedConfiguration: ConfigurationType
        #if targetEnvironment(simulator)
            if case .basic(nil) = configuration {
                let projectDir = ProcessInfo.processInfo.environment["SRCROOT"] ?? ""
                if !projectDir.isEmpty {
                    resolvedConfiguration = .basic(url: "\(projectDir)/default.realm")
                } else {
                    resolvedConfiguration = configuration
                }
            } else {
                resolvedConfiguration = configuration
            }
        #else
            resolvedConfiguration = configuration
        #endif
        return resolvedConfiguration
    }

    /// Private initializer - use create(configuration:) instead
    private init(realm: Realm) {
        self.realm = realm
    }

    /// Fetch objects with optional predicate and sorting (async)
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) async -> [T] {
        guard let objectType = model as? Object.Type else { return [] }

        var objects = realm.objects(objectType)

        if let predicate {
            objects = objects.filter(predicate)
        }

        if let sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }

        return objects.compactMap { $0 as? T }
    }

    /// Fetch a single object by primary key (async)
    func fetchByKey<T: Storable>(_ model: T.Type, key: Any) async -> T? {
        guard let objectType = model as? Object.Type else { return nil }
        return realm.object(ofType: objectType, forPrimaryKey: key) as? T
    }

    /// Create a new object (async)
    func create<T: Storable>(_ model: T.Type, value: Any, update: UpdatePolicy) async throws -> T {
        guard let objectType = model as? Object.Type else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        let realmPolicy = update.toRealmPolicy()

        return try await write {
            guard let result = self.realm.create(objectType, value: value, update: realmPolicy) as? T else {
                throw RealmDatabaseError.objectCouldNotBeParsed
            }
            return result
        }
    }

    /// Save an object to the database (async)
    func save(object: Storable, update: UpdatePolicy) async throws {
        guard let realmObject = object as? Object else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        try await write {
            self.realm.add(realmObject, update: update.toRealmPolicy())
        }
    }

    /// Update objects within a write transaction (async)
    func update(_ block: @escaping () throws -> Void) async throws {
        try await write(block)
    }

    /// Delete an object from the database (async)
    func delete(object: Storable) async throws {
        guard let realmObject = object as? Object else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        try await write {
            self.realm.delete(realmObject)
        }
    }

    /// Delete all objects of a specific type (async)
    func deleteAll(_ model: (some Storable).Type) async throws {
        guard let objectType = model as? Object.Type else {
            throw RealmDatabaseError.objectCouldNotBeParsed
        }

        try await write {
            let objects = self.realm.objects(objectType)
            self.realm.delete(objects)
        }
    }

    /// Delete all objects in the database (async)
    func reset() async throws {
        try await write {
            self.realm.deleteAll()
        }
    }

    /// Observe changes to a query (returns AsyncStream)
    func observe<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AsyncStream<[T]> {
        guard let objectType = model as? Object.Type else {
            return AsyncStream { continuation in
                continuation.finish()
            }
        }

        return AsyncStream { continuation in
            var objects = realm.objects(objectType)

            if let predicate {
                objects = objects.filter(predicate)
            }

            if let sorted {
                objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
            }

            // Send initial value
            continuation.yield(objects.compactMap { $0 as? T })

            // Observe changes
            let token = objects.observe { changes in
                switch changes {
                case let .initial(results):
                    continuation.yield(results.compactMap { $0 as? T })
                case let .update(results, _, _, _):
                    continuation.yield(results.compactMap { $0 as? T })
                case .error:
                    continuation.finish()
                }
            }

            continuation.onTermination = { _ in
                token.invalidate()
            }
        }
    }

    // MARK: - Private Write Helper

    /// Execute a write transaction
    /// - Parameter block: The block to execute within the transaction
    private func write<T>(_ block: @escaping () throws -> T) async throws -> T {
        // Already on Main Actor due to @MainActor class annotation
        if realm.isInWriteTransaction {
            return try block()
        } else {
            return try realm.write {
                try block()
            }
        }
    }
}

// MARK: - UpdatePolicy Extension

extension UpdatePolicy {
    /// Convert UpdatePolicy to Realm.UpdatePolicy
    func toRealmPolicy() -> Realm.UpdatePolicy {
        switch self {
        case .error:
            return .error
        case .modified:
            return .modified
        case .all:
            return .all
        }
    }
}
