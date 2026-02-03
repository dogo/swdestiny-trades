//
//  TestContainer.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

final class TestContainer {
    private let dependencyManager: DependencyManagerProtocol
    let container: DependencyContainer

    init() {
        dependencyManager = TestDependencyManager()
        container = DependencyContainer(dependencyManager: dependencyManager)
    }

    func registerMock<T>(_ type: T.Type, mock: @escaping () -> T) {
        container.register(type: type, dependency: mock)
    }

    func resolve<T>(_ type: T.Type, mode: InstanceMode = .shared) -> T {
        return container.resolve(type: type, mode: mode)
    }

    func remove(type: (some Any).Type) {
        container.remove(type: type)
    }

    func clearAll() {
        if let testManager = dependencyManager as? TestDependencyManager {
            testManager.clearAll()
        }
    }
}
