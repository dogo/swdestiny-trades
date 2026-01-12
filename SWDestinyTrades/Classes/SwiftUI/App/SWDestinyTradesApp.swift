//
//  SWDestinyTradesApp.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

@main
struct SWDestinyTradesApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.dependencyContainer, appState.dependencyContainer)
                .environment(\.viewModelFactory, ViewModelFactory(container: appState.dependencyContainer))
                .onAppear {
                    if !appState.isInitialized, !appState.isLoading {
                        appState.initialize()
                    }
                }
        }
    }
}
