//
//  MainTabView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @EnvironmentObject var appState: AppState
    @Environment(\.dependencyContainer) var dependencyContainer
    @Environment(\.viewModelFactory) var viewModelFactory

    var body: some View {
        TabView(selection: $navigationCoordinator.selectedTab) {
            NavigationStack(path: navigationCoordinator.path(for: .cards)) {
                CardsRootView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        NavigationDestinationBuilder.build(destination: destination)
                    }
            }
            .tabItem {
                Image(asset: Asset.Tabbar.icCards)
                Text(L10n.cards)
            }
            .tag(AppTab.cards)

            NavigationStack(path: navigationCoordinator.path(for: .decks)) {
                DecksRootView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        NavigationDestinationBuilder.build(destination: destination)
                    }
            }
            .tabItem {
                Image(asset: Asset.Tabbar.icDecks)
                Text(L10n.decks)
            }
            .tag(AppTab.decks)

            NavigationStack(path: navigationCoordinator.path(for: .loans)) {
                LoansRootView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        NavigationDestinationBuilder.build(destination: destination)
                    }
            }
            .tabItem {
                Image(asset: Asset.Tabbar.icLoans)
                Text(L10n.loans)
            }
            .tag(AppTab.loans)

            NavigationStack(path: navigationCoordinator.path(for: .collection)) {
                CollectionRootView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        NavigationDestinationBuilder.build(destination: destination)
                    }
            }
            .tabItem {
                Image(asset: Asset.Tabbar.icCollection)
                Text(L10n.collection)
            }
            .tag(AppTab.collection)
        }
        .environmentObject(navigationCoordinator)
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

// MARK: - Optimized Root Views for Each Tab

struct CardsRootView: View {
    var body: some View {
        SetsListView()
    }
}

struct DecksRootView: View {
    var body: some View {
        DeckListView()
    }
}

struct LoansRootView: View {
    var body: some View {
        PeopleListView()
    }
}

struct CollectionRootView: View {
    var body: some View {
        UserCollectionView()
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environment(\.dependencyContainer, DependencyContainer.shared)
        .environment(\.viewModelFactory, ViewModelFactory(container: DependencyContainer.shared))
}
