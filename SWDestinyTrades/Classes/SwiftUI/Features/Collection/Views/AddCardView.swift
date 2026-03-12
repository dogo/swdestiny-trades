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
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss

    @State private var showingFilterSheet = false
    @State private var showToast = false

    init(context: AddCardContext) {
        _viewModel = State(wrappedValue: AddCardViewModel(context: context))
    }

    init(personId: String, type: AddCardType) {
        _viewModel = State(wrappedValue: AddCardViewModel(personId: personId, type: type))
    }

    var body: some View {
        ZStack(alignment: .top) {
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

            if showToast {
                ToastView(
                    title: viewModel.toastTitle,
                    message: viewModel.toastMessage,
                    type: viewModel.toastType,
                    isPresented: $showToast,
                    duration: viewModel.toastType == .success ? 2.0 : 2.5
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
        .task {
            await viewModel.loadData()
        }
    }

    @ViewBuilder private var cardListContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: L10n.noCardsFound,
                message: viewModel.searchText.isEmpty ? L10n.pullToRefreshToLoadCards : L10n.noCardsMatchSearch,
                systemImage: "rectangle.stack"
            )
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

    @ViewBuilder private var filterButton: some View {
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
