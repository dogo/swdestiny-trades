//
//  UserCollectionView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct UserCollectionView: View {
    @State private var viewModel: UserCollectionViewModel
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator

    @State private var showingFilterSheet = false
    @State private var showingShareSheet = false
    @State private var showToast = false

    init(viewModel: UserCollectionViewModel? = nil) {
        if let viewModel {
            _viewModel = State(wrappedValue: viewModel)
        } else {
            _viewModel = State(wrappedValue: UserCollectionViewModel())
        }
    }

    var body: some View {
        content
            .navigationTitle(L10n.myCollection)
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarContent }
            .refreshable { viewModel.loadCollection() }
            .searchable(text: $viewModel.searchText, prompt: L10n.searchCollection)
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performFiltering(searchText: newValue)
            }
            .onChange(of: viewModel.filter) { _, _ in viewModel.applyFilters() }
            .onChange(of: viewModel.showToast) { _, newValue in
                showToast = newValue
            }
            .overlay(alignment: .top) {
                toastView
            }
            .sheet(isPresented: $showingFilterSheet) {
                filterSheet
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [generateShareTextForSheet()])
            }
    }

    @ViewBuilder private var content: some View {
        VStack {
            if viewModel.isLoading, viewModel.items.isEmpty {
                LoadingView()
            } else {
                collectionContent
            }
        }
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.loadCollection()
            }
            if viewModel.availableSets.isEmpty {
                viewModel.loadAvailableSets()
            }
        }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            filterButton
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            shareButton
            addButton
        }
    }

    @ViewBuilder private var toastView: some View {
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

    // MARK: - View Components

    @ViewBuilder private var collectionContent: some View {
        if viewModel.filteredItems.isEmpty, !viewModel.isLoading {
            EmptyStateView(
                title: L10n.noCardsFound,
                message: viewModel.searchText.isEmpty ? L10n.collectionEmpty : L10n.noCardsMatchSearch,
                systemImage: "rectangle.stack"
            )
        } else {
            collectionList
        }
    }

    @ViewBuilder private var collectionList: some View {
        List(viewModel.filteredItems, id: \.code) { card in
            CollectionCardRowView(card: card) { updatedCard, quantity in
                Task {
                    await viewModel.updateCardQuantity(updatedCard, quantity: quantity)
                }
            } onTap: {
                navigationCoordinator.navigate(to: .cardDetail(viewModel.filteredItems, card))
            } onRemove: { card in
                viewModel.removeCard(card)
            }
            .listRowSeparator(.visible)
        }
        .listStyle(.plain)
    }

    @ViewBuilder private var filterSheet: some View {
        UnifiedFilterView(
            filter: $viewModel.filter,
            availableSets: viewModel.availableSets
        ) {
            viewModel.applyFilters()
        }
    }

    // MARK: - Toolbar Items

    @ViewBuilder private var filterButton: some View {
        FilterToolbarButton(hasActiveFilters: viewModel.hasActiveFilters) {
            showingFilterSheet = true
        }
    }

    @ViewBuilder private var shareButton: some View {
        Button(L10n.share, systemImage: "square.and.arrow.up") {
            showingShareSheet = true
        }
    }

    @ViewBuilder private var addButton: some View {
        Button(L10n.addCard, systemImage: "plus") {
            navigationCoordinator.navigate(to: .addCard)
        }
    }

    // MARK: - Helper Methods

    private func generateShareTextForSheet() -> String {
        var collectionText = "\(L10n.myCollection)\n\n"

        for card in viewModel.filteredItems.filter({ $0.quantity > 0 }) {
            collectionText += "\(card.quantity)x \(card.name)\n"
        }

        return collectionText
    }
}

// MARK: - Supporting Views

#Preview {
    NavigationStack {
        UserCollectionView()
    }
    .environment(NavigationCoordinator())
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
