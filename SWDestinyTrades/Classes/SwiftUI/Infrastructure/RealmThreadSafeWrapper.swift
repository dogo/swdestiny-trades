//
//  RealmThreadSafeWrapper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation
import RealmSwift

protocol ThreadSafeConvertible {
    associatedtype ThreadSafeType
    func toThreadSafe() -> ThreadSafeType
}

// MARK: - Object Extensions

@MainActor
extension Object {
    func threadSafe<T>(_ keyPath: KeyPath<Object, T>) -> T? {
        return self[keyPath: keyPath]
    }

    func threadSafeList<T>(_ keyPath: KeyPath<Object, List<T>>) -> [T] where T: Object {
        return Array(self[keyPath: keyPath])
    }

    func threadSafeValue<T>(_ keyPath: KeyPath<Object, T>) -> T {
        return self[keyPath: keyPath]
    }
}

// MARK: - List Extensions

@MainActor
extension List {
    func threadSafeArray() -> [Element] {
        return Array(self)
    }

    func threadSafeCount() -> Int {
        return count
    }

    func threadSafeSum<T>(ofProperty property: String) -> T where T: _HasPersistedType, T.PersistedType: AddableType {
        return sum(ofProperty: property)
    }
}

// MARK: - Results Extensions

@MainActor
extension Results {
    func threadSafeArray() -> [Element] {
        return Array(self)
    }

    func threadSafeCount() -> Int {
        return count
    }
}

// MARK: - Thread Safe Realm Wrapper

@MainActor
enum ThreadSafeRealmWrapper {
    /// - Parameter operation: The operation to execute
    /// - Returns: The result of the operation
    static func execute<T>(_ operation: @escaping () -> T) -> T {
        // Already on Main Actor due to @MainActor annotation
        return operation()
    }

    /// - Parameter operation: The async operation to execute
    /// - Returns: The result of the operation
    static func executeAsync<T>(_ operation: @escaping () -> T) async -> T {
        // Already on Main Actor due to @MainActor annotation
        return operation()
    }
}

// MARK: - Array Extensions

@MainActor
extension Array where Element: Object {
    func threadSafeMap<T>(_ transform: @escaping (Element) -> T) -> [T] {
        return map(transform)
    }

    func threadSafeFilter(_ predicate: @escaping (Element) -> Bool) -> [Element] {
        return filter(predicate)
    }

    func threadSafeSorted(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) -> [Element] {
        return sorted(by: areInIncreasingOrder)
    }
}
