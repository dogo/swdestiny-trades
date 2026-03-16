//
//  SetsListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct SetsListView: View {
    @State private var viewModel: SetsListViewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator

    init(viewModel: SetsListViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? SetsListViewModel())
    }

    var body: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                SetsLoadingView()
            } else if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
                if viewModel.searchText.isEmpty {
                    ContentUnavailableView(L10n.noSetsFound, systemImage: "rectangle.stack",
                                           description: Text(L10n.pullToRefreshToLoadSets))
                } else {
                    ContentUnavailableView.search
                }
            } else {
                List(viewModel.filteredItems, id: \.code) { set in
                    SetRowView(set: set) {
                        navigationCoordinator.navigate(to: .cardList(set))
                    }
                    .listRowSeparator(.visible)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(L10n.expansions)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(L10n.about, systemImage: "info.circle") {
                    navigationCoordinator.navigate(to: .about)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(L10n.search, systemImage: "magnifyingglass") {
                    navigationCoordinator.navigate(to: .search)
                }
            }
        }
        .refreshable {
            await viewModel.refreshSets()
        }
        .toastQueue(viewModel.toastQueue)
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .searchable(text: $viewModel.searchText, prompt: L10n.searchSets)
        .task {
            if viewModel.items.isEmpty {
                await viewModel.loadItems()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SetsListView()
    }
    .environment(NavigationCoordinator())
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
