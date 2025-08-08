//
//  InjectionWrapper.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/08/25.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

@propertyWrapper
struct Inject<Value> {
    private(set) var wrappedValue: Value

    init(container: DependencyManagerProtocol = DependencyManager.shared,
         key: String? = nil,
         mode: InstanceMode = .shared) {
        if let key {
            wrappedValue = container.resolve(key: key, mode: mode)
        } else {
            wrappedValue = container.resolve(type: Value.self, mode: mode)
        }
    }
}

@propertyWrapper
struct LazyInject<Value> {

    private let container: DependencyManagerProtocol
    private let key: String?
    private let mode: InstanceMode

    private(set) lazy var wrappedValue: Value = {
        if let key {
            return container.resolve(key: key, mode: mode)
        } else {
            return container.resolve(type: Value.self, mode: mode)
        }
    }()

    init(container: DependencyManagerProtocol = DependencyManager.shared,
         key: String? = nil,
         mode: InstanceMode = .shared) {
        self.container = container
        self.key = key
        self.mode = mode
    }
}

@propertyWrapper
struct WeakInject<Value> {

    private weak var underlyingValue: AnyObject?

    var wrappedValue: Value? {
        return underlyingValue as? Value
    }

    init(container: DependencyManagerProtocol = DependencyManager.shared,
         key: String? = nil,
         mode: InstanceMode = .shared) {
        if let key {
            underlyingValue = container.resolve(key: key, mode: mode)
        } else {
            underlyingValue = container.resolve(type: Value.self, mode: mode) as AnyObject
        }
    }
}
