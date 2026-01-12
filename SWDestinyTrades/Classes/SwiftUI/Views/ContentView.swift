//
//  ContentView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

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
                ErrorView(message: "App failed to initialize") {
                    appState.reset()
                    appState.initialize()
                }
            }
        }
    }
}

struct SharedLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text(L10n.loading)
                .padding(.top)
        }
    }
}

struct ErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            Text(L10n.error)
                .font(.title)
                .fontWeight(.bold)

            Text(message)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(L10n.retry) {
                retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct PlaceholderMainView: View {
    var body: some View {
        VStack {
            Text(L10n.swdestinyTrades)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(L10n.swiftuiMigrationInProgress)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(L10n.appInitializedSuccessfully)
                .padding(.top)
                .foregroundColor(.green)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
