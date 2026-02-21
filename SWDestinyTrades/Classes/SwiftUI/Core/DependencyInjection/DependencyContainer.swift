//
//  DependencyContainer.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

final class DependencyContainer {

    static let shared = DependencyContainer()

    private let dependencyManager: DependencyManagerProtocol

    init(dependencyManager: DependencyManagerProtocol = DependencyManager.shared) {
        self.dependencyManager = dependencyManager
    }

    func register<DependencyType>(type: DependencyType.Type, dependency: @escaping () -> DependencyType) {
        dependencyManager.register(type: type, dependency: dependency)
    }

    func resolve<DependencyType>(type: DependencyType.Type, mode: InstanceMode = .shared) -> DependencyType {
        return dependencyManager.resolve(type: type, mode: mode)
    }

    func remove(type: (some Any).Type) {
        dependencyManager.remove(type: type)
    }

    @MainActor
    func createViewModel<T: BaseViewModel>(_ viewModelType: T.Type) -> T {
        return viewModelType.init(dependencyContainer: self)
    }
}

struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer.shared
}

extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
