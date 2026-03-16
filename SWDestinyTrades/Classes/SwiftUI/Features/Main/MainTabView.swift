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
            Tab(value: AppTab.sets) {
                TabNavigationStack(path: $navigationCoordinator.setsPath) { SetsRootView() }
            } label: {
                Label { Text(L10n.cards) } icon: { Asset.Tabbar.icCards.swiftUIImage }
            }
            Tab(value: AppTab.decks) {
                TabNavigationStack(path: $navigationCoordinator.deckPath) { DecksRootView() }
            } label: {
                Label { Text(L10n.decks) } icon: { Asset.Tabbar.icDecks.swiftUIImage }
            }
            Tab(value: AppTab.loans) {
                TabNavigationStack(path: $navigationCoordinator.loanPath) { LoansRootView() }
            } label: {
                Label { Text(L10n.loans) } icon: { Asset.Tabbar.icLoans.swiftUIImage }
            }
            Tab(value: AppTab.collection) {
                TabNavigationStack(path: $navigationCoordinator.collectionPath) { CollectionRootView() }
            } label: {
                Label { Text(L10n.collection) } icon: { Asset.Tabbar.icCollection.swiftUIImage }
            }
        }
        .environment(navigationCoordinator)
        .onAppear {
            setupTabBarAppearance()
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.selectionIndicatorTintColor = UIColor.systemBlue

        let normalItemAppearance = UITabBarItemAppearance()
        normalItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        normalItemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]

        appearance.stackedLayoutAppearance = normalItemAppearance
        appearance.inlineLayoutAppearance = normalItemAppearance
        appearance.compactInlineLayoutAppearance = normalItemAppearance

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
        .environment(\.dependencyContainer, DependencyContainer.shared)
        .environment(\.viewModelFactory, ViewModelFactory(container: DependencyContainer.shared))
}
