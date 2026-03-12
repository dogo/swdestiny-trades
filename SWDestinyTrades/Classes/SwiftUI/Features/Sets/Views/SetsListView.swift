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
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dependencyContainer) private var container

    @State private var showToast = false

    init(viewModel: SetsListViewModel? = nil) {
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: SetsListViewModel())
        }
    }

    var body: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                SetsLoadingView()
            } else {
                setsListContent
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
            await refreshSets()
        }
        .overlay(alignment: .top) {
            if showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $showToast,
                    duration: 2.5
                )
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showToast)
        .onChange(of: viewModel.showToast) { _, newValue in
            showToast = newValue
        }
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

    @ViewBuilder private var setsListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: L10n.noSetsFound,
                message: viewModel.searchText.isEmpty ? L10n.pullToRefreshToLoadSets : L10n.noSetsMatchSearch,
                systemImage: "rectangle.stack"
            )
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

    @MainActor
    private func refreshSets() async {
        await viewModel.refreshSets()
    }
}

struct SetsLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        SetsListView()
    }
    .environment(NavigationCoordinator())
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
