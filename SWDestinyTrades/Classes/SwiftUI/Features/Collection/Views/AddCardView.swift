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

    var body: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                LoadingView()
            } else {
                AddCardListContent(
                    filteredItems: viewModel.filteredItems,
                    isLoading: viewModel.isLoading,
                    searchText: viewModel.searchText,
                    onAddCard: { viewModel.addCard($0) },
                    onDetailTap: { card in
                        navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
                    }
                )
            }
        }
        .navigationTitle(viewModel.addCardContext.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FilterToolbarButton(hasActiveFilters: viewModel.filter.hasActiveFilters) {
                    showingFilterSheet = true
                }
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
        .toastQueue(viewModel.toastQueue)
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performFiltering(searchText: newValue)
        }
        .task {
            await viewModel.loadData()
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
