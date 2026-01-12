//
//  ViewModelFactory.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

final class ViewModelFactory: ObservableObject {

    private let container: DependencyContainer

    init(container: DependencyContainer = .shared) {
        self.container = container
    }

    @MainActor
    func create<T: ObservableObject>(_ viewModelType: T.Type) -> T {
        return container.createViewModel(viewModelType)
    }
}

struct ViewModelFactoryKey: EnvironmentKey {
    static let defaultValue = ViewModelFactory()
}

extension EnvironmentValues {
    var viewModelFactory: ViewModelFactory {
        get { self[ViewModelFactoryKey.self] }
        set { self[ViewModelFactoryKey.self] = newValue }
    }
}
