//
//  DatabaseProtocol.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 08/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

protocol Storable {}

struct Sorted {
    var key: String
    var ascending: Bool
}

/// Update policy for database operations
/// Determines how conflicts are handled when saving objects
enum UpdatePolicy {
    /// Throw an error if an object with the same primary key already exists
    case error
    /// Update only properties that have changed
    case modified
    /// Update all properties, even if unchanged
    case all
}

/// Protocol defining the database abstraction layer
protocol DatabaseProtocol: AnyObject {

    /// Fetch objects with optional predicate and sorting (async)
    /// - Parameters:
    ///   - model: The type of object to fetch
    ///   - predicate: Optional predicate to filter results
    ///   - sorted: Optional sorting configuration
    /// - Returns: Array of fetched objects
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) async -> [T]

    /// Fetch a single object by primary key (async)
    /// - Parameters:
    ///   - model: The type of object to fetch
    ///   - key: The primary key value
    /// - Returns: The fetched object, or nil if not found
    func fetchByKey<T: Storable>(_ model: T.Type, key: Any) async -> T?

    /// Create a new object (async)
    /// - Parameters:
    ///   - model: The type of object to create
    ///   - value: The values to initialize the object with
    ///   - update: The update policy to use if object already exists
    /// - Returns: The created object
    /// - Throws: Database errors if creation fails
    func create<T: Storable>(_ model: T.Type, value: Any, update: UpdatePolicy) async throws -> T

    /// Save an object (async)
    /// - Parameters:
    ///   - object: The object to save
    ///   - update: The update policy to use
    /// - Throws: Database errors if save fails
    func save(object: Storable, update: UpdatePolicy) async throws

    /// Delete an object (async)
    /// - Parameter object: The object to delete
    /// - Throws: Database errors if deletion fails
    func delete(object: Storable) async throws

    /// Delete all objects of a type (async)
    /// - Parameter model: The type of objects to delete
    /// - Throws: Database errors if deletion fails
    func deleteAll(_ model: (some Storable).Type) async throws

    /// Reset/delete all data (async)
    /// - Throws: Database errors if reset fails
    func reset() async throws

    /// Observe changes to a query (returns AsyncStream)
    /// - Parameters:
    ///   - model: The type of object to observe
    ///   - predicate: Optional predicate to filter results
    ///   - sorted: Optional sorting configuration
    /// - Returns: AsyncStream that emits arrays of objects when changes occur
    func observe<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AsyncStream<[T]>
}
