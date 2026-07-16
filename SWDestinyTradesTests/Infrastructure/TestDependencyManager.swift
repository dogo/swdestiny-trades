//
//  TestDependencyManager.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

@testable import SWDestinyTrades

@MainActor
final class TestDependencyManager: DependencyManagerProtocol {
    private var dependencyInitializer: [String: () -> Any] = [:]
    private var dependencyShared: [String: Any] = [:]

    init() {}

    func register<DependencyType>(type: DependencyType.Type, dependency: @escaping () -> DependencyType) {
        register(key: dependencyKey(for: type), dependency: dependency)
    }

    func register(key: String, dependency: @escaping () -> some Any) {
        dependencyInitializer[key] = dependency
    }

    func remove(type: (some Any).Type) {
        let key = dependencyKey(for: type)
        dependencyInitializer[key] = nil
        dependencyShared[key] = nil
    }

    func resolve<DependencyType>(type: DependencyType.Type, mode: InstanceMode) -> DependencyType {
        return resolve(key: dependencyKey(for: type), mode: mode)
    }

    func resolve<DependencyType>(key: String, mode: InstanceMode) -> DependencyType {
        switch mode {
        case .new:
            guard let newDependency = dependencyInitializer[key]?() as? DependencyType else {
                preconditionFailure("TestDependencyManager.resolve. There is no dependency registered for this type \(DependencyType.self).")
            }

            return newDependency

        case .shared:
            if dependencyShared[key] == nil,
               let dependency = dependencyInitializer[key]?() {
                dependencyShared[key] = dependency
            }

            guard let sharedDependency = dependencyShared[key] as? DependencyType else {
                preconditionFailure("TestDependencyManager.resolve. There is no dependency registered for this type \(DependencyType.self).")
            }

            return sharedDependency
        }
    }

    func clearAll() {
        dependencyInitializer.removeAll()
        dependencyShared.removeAll()
    }

    private func dependencyKey(for type: (some Any).Type) -> String {
        String(describing: type)
    }
}
