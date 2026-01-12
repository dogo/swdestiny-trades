//
//  RealmManager.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 17/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

/// Modern async/await-based Realm manager that ensures Main Actor isolation
@MainActor
final class RealmManager {
    private let realm: Realm

    /// Initialize with default configuration
    convenience init() throws {
        #if targetEnvironment(simulator)
            let configuration = ConfigurationType.basic(url: "\(RealmManager.realHomeDirectory())/Desktop/default.realm")
            try self.init(configuration: configuration)
        #else
            try self.init(configuration: .basic(url: nil))
        #endif
    }

    /// Initialize with specific configuration
    init(configuration: ConfigurationType = .basic(url: nil)) throws {
        var rmConfig = Realm.Configuration()

        switch configuration {
        case .basic:
            rmConfig = Realm.Configuration.defaultConfiguration
            if let url = configuration.associated {
                rmConfig.fileURL = URL(string: url)
            }
        case .inMemory:
            rmConfig = Realm.Configuration()
            if let identifier = configuration.associated {
                rmConfig.inMemoryIdentifier = identifier
            } else {
                throw RealmDatabaseError.invalidMemory(identifier: configuration.associated)
            }
        }

        rmConfig.schemaVersion = RealmMigrations.schemaVersion
        realm = try Realm(configuration: rmConfig)
    }

    // MARK: - Async Fetch Methods

    /// Fetch objects of a specific type with optional predicate and sorting
    /// - Parameters:
    ///   - type: The type of object to fetch
    ///   - predicate: Optional predicate to filter results
    ///   - sorted: Optional sorting configuration
    /// - Returns: Array of fetched objects converted to Sendable types
    func fetch<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil) async -> [T] {
        var objects = realm.objects(type)

        if let predicate {
            objects = objects.filter(predicate)
        }

        if let sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }

        return Array(objects)
    }

    /// Fetch objects with a completion handler (for compatibility with existing code)
    /// - Parameters:
    ///   - type: The type of object to fetch
    ///   - predicate: Optional predicate to filter results
    ///   - sorted: Optional sorting configuration
    ///   - completion: Completion handler with fetched results
    func fetch<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: @escaping ([T]) -> Void) {
        Task {
            let results = await fetch(type, predicate: predicate, sorted: sorted)
            completion(results)
        }
    }

    /// Fetch a single object by primary key
    /// - Parameters:
    ///   - type: The type of object to fetch
    ///   - key: The primary key value
    /// - Returns: The object if found, nil otherwise
    func fetchByKey<T: Object>(_ type: T.Type, key: Any) async -> T? {
        return realm.object(ofType: type, forPrimaryKey: key)
    }

    // MARK: - Async Write Methods

    /// Create a new object
    /// - Parameters:
    ///   - type: The type of object to create
    ///   - value: The value to initialize the object with
    ///   - update: Update policy
    /// - Returns: The created object
    func create<T: Object>(_ type: T.Type, value: Any = [:], update: Realm.UpdatePolicy = .error) async throws -> T {
        try await write {
            return self.realm.create(type, value: value, update: update)
        }
    }

    /// Save an object to the database
    /// - Parameters:
    ///   - object: The object to save
    ///   - update: Update policy
    func save(_ object: some Object, update: Realm.UpdatePolicy = .modified) async throws {
        try await write {
            self.realm.add(object, update: update)
        }
    }

    /// Update objects within a write transaction
    /// - Parameter block: The update block to execute
    func update(_ block: @escaping () throws -> Void) async throws {
        try await write(block)
    }

    /// Delete an object from the database
    /// - Parameter object: The object to delete
    func delete(_ object: some Object) async throws {
        try await write {
            self.realm.delete(object)
        }
    }

    /// Delete all objects of a specific type
    /// - Parameter type: The type of objects to delete
    func deleteAll(_ type: (some Object).Type) async throws {
        try await write {
            let objects = self.realm.objects(type)
            self.realm.delete(objects)
        }
    }

    /// Delete all objects in the database
    func reset() async throws {
        try await write {
            self.realm.deleteAll()
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

    // MARK: - Utility

    private static func realHomeDirectory() -> String {
        let homeDirectory = NSHomeDirectory()
        let pathComponents = homeDirectory.components(separatedBy: "/")
        return "/\(pathComponents[1])/\(pathComponents[2])"
    }
}

// MARK: - Sendable Conversion Helpers

@MainActor
extension RealmManager {
    /// Fetch objects and convert them to Sendable types using a transform
    /// - Parameters:
    ///   - type: The type of object to fetch
    ///   - predicate: Optional predicate to filter results
    ///   - sorted: Optional sorting configuration
    ///   - transform: Transform function to convert Realm objects to Sendable types
    /// - Returns: Array of transformed Sendable objects
    func fetchAndConvert<T: Object, U: Sendable>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sorted: Sorted? = nil,
        transform: @escaping (T) -> U
    ) async -> [U] {
        let objects = await fetch(type, predicate: predicate, sorted: sorted)
        return objects.map(transform)
    }
}
