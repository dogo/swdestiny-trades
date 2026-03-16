//
//  AddCardView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct AddCardView: View {
    @State private var viewModel: AddCardViewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss

    @State private var showingFilterSheet = false

    init(context: AddCardContext) {
        _viewModel = State(wrappedValue: AddCardViewModel(context: context))
    }

    init(personId: String, type: AddCardType) {
        _viewModel = State(wrappedValue: AddCardViewModel(personId: personId, type: type))
    }

    var body: some View {
        cardListView
            .toastQueue(viewModel.toastQueue)
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performFiltering(searchText: newValue)
            }
            .task {
                await viewModel.loadData()
            }
    }

    private var cardListView: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                LoadingView()
            } else {
                cardListContent
            }
        }
        .navigationTitle(viewModel.addCardContext.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                filterButton
            }
        }
        .searchable(text: $viewModel.searchText, prompt: L10n.searchCards)
        .refreshable {
            await refreshCards()
        }
        .sheet(isPresented: $showingFilterSheet) {
            UnifiedFilterView(
                filter: $viewModel.filter,
                availableSets: viewModel.availableSets
            ) {
                viewModel.applyFilters()
            }
        }
    }

    @ViewBuilder private var cardListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            if viewModel.searchText.isEmpty {
                ContentUnavailableView(L10n.noCardsFound, systemImage: "rectangle.stack",
                                       description: Text(L10n.pullToRefreshToLoadCards))
            } else {
                ContentUnavailableView.search
            }
        } else {
            List(viewModel.filteredItems, id: \.code) { card in
                AddCardDetailRowView(card: card) {
                    viewModel.addCard(card)
                } onDetailTap: {
                    navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
        }
    }

    private var filterButton: some View {
        FilterToolbarButton(hasActiveFilters: viewModel.filter.hasActiveFilters) {
            showingFilterSheet = true
        }
    }

    @MainActor
    private func refreshCards() async {
        await viewModel.loadAllCards()
    }
}

#Preview {
    let mockCollection = UserCollectionDTO()

    AddCardView(context: .collection(mockCollection))
        .environment(NavigationCoordinator())
        .environment(\.dependencyContainer, DependencyContainer.shared)
}
