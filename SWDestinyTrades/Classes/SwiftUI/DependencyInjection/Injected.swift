//
//  Injected.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@propertyWrapper
struct Injected<T> {
    private let keyPath: KeyPath<DependencyContainer, T>
    private let container: DependencyContainer

    var wrappedValue: T {
        container[keyPath: keyPath]
    }

    init(_ keyPath: KeyPath<DependencyContainer, T>, container: DependencyContainer = .shared) {
        self.keyPath = keyPath
        self.container = container
    }
}

@propertyWrapper
struct Resolved<T> {
    private let type: T.Type
    private let mode: InstanceMode
    private let container: DependencyContainer

    var wrappedValue: T {
        container.resolve(type: type, mode: mode)
    }

    init(_ type: T.Type, mode: InstanceMode = .shared, container: DependencyContainer = .shared) {
        self.type = type
        self.mode = mode
        self.container = container
    }
}

extension DependencyContainer {

    var httpClient: HttpClientProtocol {
        resolve(type: HttpClientProtocol.self)
    }

    var database: DatabaseProtocol? {
        resolve(type: DatabaseProtocol.self)
    }
}
