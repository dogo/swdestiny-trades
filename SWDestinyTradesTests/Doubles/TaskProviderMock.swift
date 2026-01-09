//
//  TaskProviderMock.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 09/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

public final class SynchronizedArray<Element>: @unchecked Sendable {
    private var underlyingArray: [Element]
    private let queue = DispatchQueue(label: "com.testable-swift-concurrency.synchronizedArray", attributes: .concurrent)

    public init(_ underlyingArray: [Element] = []) {
        self.underlyingArray = underlyingArray
    }

    public var content: [Element] {
        get { queue.sync { underlyingArray } }
        set { queue.sync(flags: .barrier) { underlyingArray = newValue } }
    }

    public func append(_ element: Element) {
        queue.sync(flags: .barrier) {
            underlyingArray.append(element)
        }
    }
}

public final class SynchronizedValue<Value: Sendable>: @unchecked Sendable {
    private var underlyingValue: Value
    private let queue = DispatchQueue(label: "com.testable-swift-concurrency.synchronizedValue", attributes: .concurrent)

    public init(_ initialValue: Value) {
        underlyingValue = initialValue
    }

    public var value: Value {
        get { queue.sync { underlyingValue } }
        set { queue.sync(flags: .barrier) { underlyingValue = newValue } }
    }
}

public extension SynchronizedValue where Value == Int {
    func increment(by amount: Int = 1) {
        queue.sync(flags: .barrier) {
            underlyingValue += amount
        }
    }
}

public final class TaskProviderMock: TaskProvider, Sendable {
    public enum MethodCall: Equatable, Sendable {
        case task(priority: TaskPriority?)
        case detachedTask(priority: TaskPriority?)
    }

    public let log = SynchronizedArray<MethodCall>([])
    private let completedTasksCount = SynchronizedValue(0)
    private let tasksCount = SynchronizedValue(0)

    public init() {}

    public func task<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async -> Success) -> Task<Success, Never> {
        log.append(.task(priority: priority))
        tasksCount.increment()
        return Task(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            let result = await operation()
            return result
        }
    }

    public func task<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Error> {
        log.append(.task(priority: priority))
        tasksCount.increment()
        return Task(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            do {
                let result = try await operation()
                return result
            } catch {
                throw error
            }
        }
    }

    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async -> Success) -> Task<Success, Never> {
        log.append(.detachedTask(priority: priority))
        tasksCount.increment()
        return Task.detached(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            let result = await operation()
            return result
        }
    }

    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Error> {
        log.append(.detachedTask(priority: priority))
        tasksCount.increment()
        return Task.detached(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            do {
                let result = try await operation()
                return result
            } catch {
                throw error
            }
        }
    }

    public func waitForTasks() async {
        while completedTasksCount.value < tasksCount.value {
            await Task.yield()
        }
    }
}
