//
//  ViewModelFactory.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

final class ViewModelFactory {

    private let container: DependencyContainer

    init(container: DependencyContainer = .shared) {
        self.container = container
    }

    @MainActor
    func create<T: BaseViewModel>(_ viewModelType: T.Type) -> T {
        container.createViewModel(viewModelType)
    }
}

extension EnvironmentValues {
    @Entry var viewModelFactory: ViewModelFactory = .init()
}
