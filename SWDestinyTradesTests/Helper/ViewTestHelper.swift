//
//  ViewTestHelper.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 01/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@testable import SWDestinyTrades

@MainActor
struct ViewTestHelper {
    let container: DependencyContainer
    let navigationCoordinator: NavigationCoordinator
    let navigationCoordinatorMock: NavigationCoordinatorMock?
    let appState: AppState

    init(testContainer: TestContainer, navigationCoordinatorMock: NavigationCoordinatorMock? = nil) {
        container = testContainer.container
        navigationCoordinator = NavigationCoordinator()
        self.navigationCoordinatorMock = navigationCoordinatorMock
        appState = AppState()
    }

    func createView(@ViewBuilder content: () -> some View) -> some View {
        Group {
            if let mock = navigationCoordinatorMock {
                content()
                    .environment(\.dependencyContainer, container)
                    .environment(\.viewModelFactory, ViewModelFactory(container: container))
                    .environmentObject(mock)
                    .environmentObject(appState)
            } else {
                content()
                    .environment(\.dependencyContainer, container)
                    .environment(\.viewModelFactory, ViewModelFactory(container: container))
                    .environmentObject(navigationCoordinator)
                    .environmentObject(appState)
            }
        }
    }

    func createViewModel<T: BaseViewModel>(_ type: T.Type) -> T {
        return container.createViewModel(type)
    }
}
