//
//  TaskProvider.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 09/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

public protocol TaskProviderProtocol: Sendable {
    @discardableResult
    func task<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async -> Success) -> Task<Success, Never>

    @discardableResult
    func task<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Error>

    @discardableResult
    func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async -> Success) -> Task<Success, Never>

    @discardableResult
    func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Error>
}

public struct TaskProvider: TaskProviderProtocol {
    public init() {}

    @discardableResult
    public func task<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async -> Success) -> Task<Success, Never> {
        Task(priority: priority, operation: operation)
    }

    @discardableResult
    public func task<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Error> {
        Task(priority: priority, operation: operation)
    }

    @discardableResult
    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async -> Success) -> Task<Success, Never> {
        Task.detached(priority: priority, operation: operation)
    }

    @discardableResult
    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Error> {
        Task.detached(priority: priority, operation: operation)
    }
}
