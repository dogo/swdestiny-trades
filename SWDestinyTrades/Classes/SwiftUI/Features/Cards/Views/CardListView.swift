//
//  CardListView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CardListView: View {
    @State private var viewModel: CardListViewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator
    @State private var showingFilterOptions = false

    let set: SetDTO

    init(set: SetDTO, viewModel: CardListViewModel? = nil) {
        self.set = set
        _viewModel = State(wrappedValue: viewModel ?? CardListViewModel(set: set))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                LoadingView()
            } else {
                cardListContent
            }
        }
        .navigationTitle(set.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                FilterToolbarButton(hasActiveFilters: viewModel.filter.hasActiveFilters) {
                    showingFilterOptions = true
                }
            }
        }
        .refreshable {
            await refreshCards()
        }
        .searchable(text: $viewModel.searchText, prompt: L10n.searchCards)
        .sheet(isPresented: $showingFilterOptions) {
            UnifiedFilterView(
                filter: $viewModel.filter,
                showExpansionFilter: false
            ) {
                viewModel.performFiltering(searchText: viewModel.searchText)
            }
        }
        .toastQueue(viewModel.toastQueue)
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .task {
            await viewModel.loadCards()
        }
    }

    @ViewBuilder private var cardListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            if viewModel.searchText.isEmpty {
                ContentUnavailableView(L10n.noCardsFound,
                                       systemImage: "rectangle.stack",
                                       description: Text(L10n.pullToRefreshToLoadCards))
            } else {
                ContentUnavailableView.search
            }
        } else {
            List(viewModel.filteredItems, id: \.code) { card in
                CardRowView(card: card) {
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }

    @MainActor
    private func refreshCards() async {
        await viewModel.loadCards()
    }
}

#Preview {
    @Previewable @State var container: DependencyContainer?
    @Previewable @State var appState: AppState?

    if let container, let appState {
        NavigationStack {
            CardListView(set: SampleData.sets[0])
        }
        .environment(NavigationCoordinator())
        .environment(appState)
        .environment(\.dependencyContainer, container)
    } else {
        ProgressView()
            .task {
                do {
                    container = try await PreviewHelper.createContainer()
                    appState = try await PreviewHelper.createAppState()
                } catch {
                    print("Preview setup failed: \(error)")
                }
            }
    }
}
