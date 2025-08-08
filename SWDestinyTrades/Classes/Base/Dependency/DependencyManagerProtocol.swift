//
//  DependencyManagerProtocol.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 08/08/25.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import Foundation

enum InstanceMode {
    case new
    case shared
}

protocol DependencyManagerProtocol {
    func register<DependencyType>(type: DependencyType.Type, dependency: @escaping () -> DependencyType)
    func register(key: String, dependency: @escaping () -> some Any)

    func resolve<DependencyType>(type: DependencyType.Type, mode: InstanceMode) -> DependencyType
    func resolve<DependencyType>(key: String, mode: InstanceMode) -> DependencyType
}
