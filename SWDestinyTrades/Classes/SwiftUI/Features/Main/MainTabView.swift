//
//  MainTabView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @State private var navigationCoordinator = NavigationCoordinator()
    @Environment(AppState.self) var appState
    @Environment(\.viewModelFactory) var viewModelFactory

    var body: some View {
        TabView(selection: $navigationCoordinator.selectedTab) {
            Tab(L10n.cards, image: Asset.Tabbar.icCards.name, value: AppTab.sets) {
                TabNavigationStack(path: $navigationCoordinator.setsPath) { SetsRootView() }
            }
            Tab(L10n.decks, image: Asset.Tabbar.icDecks.name, value: AppTab.decks) {
                TabNavigationStack(path: $navigationCoordinator.deckPath) { DecksRootView() }
            }
            Tab(L10n.loans, image: Asset.Tabbar.icLoans.name, value: AppTab.loans) {
                TabNavigationStack(path: $navigationCoordinator.loanPath) { LoansRootView() }
            }
            Tab(L10n.collection, image: Asset.Tabbar.icCollection.name, value: AppTab.collection) {
                TabNavigationStack(path: $navigationCoordinator.collectionPath) { CollectionRootView() }
            }
        }
        .tint(ColorPalette.appTheme)
        .environment(navigationCoordinator)
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
        .environment(\.dependencyContainer, DependencyContainer.shared)
        .environment(\.viewModelFactory, ViewModelFactory(container: DependencyContainer.shared))
}
