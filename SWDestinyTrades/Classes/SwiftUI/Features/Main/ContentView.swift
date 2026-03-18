//
//  ContentView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var appState

    var body: some View {
        Group {
            if appState.isLoading {
                SharedLoadingView()
            } else if let errorMessage = appState.errorMessage {
                ErrorView(message: errorMessage) {
                    appState.reset()
                    appState.initialize()
                }
            } else if appState.isInitialized {
                MainTabView()
            } else {
                ErrorView(message: L10n.appFailedToInitialize) {
                    appState.reset()
                    appState.initialize()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
