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
    @Environment(NavigationCoordinator.self) private var navigationCoordinator: NavigationCoordinator
    @State private var showingFilterSheet = false
    @State private var showingShareSheet = false

    init(viewModel: UserCollectionViewModel? = nil) {
        _viewModel = State(wrappedValue: viewModel ?? UserCollectionViewModel())
    }

    var body: some View {
        CollectionContent(viewModel: viewModel)
            .navigationTitle(L10n.myCollection)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    FilterToolbarButton(hasActiveFilters: viewModel.hasActiveFilters) {
                        showingFilterSheet = true
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(L10n.share, systemImage: "square.and.arrow.up") {
                        showingShareSheet = true
                    }
                    Button(L10n.addCard, systemImage: "plus") {
                        navigationCoordinator.navigate(to: .addCard)
                    }
                }
            }
            .refreshable { viewModel.loadCollection() }
            .searchable(text: $viewModel.searchText, prompt: L10n.searchCollection)
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performFiltering(searchText: newValue)
            }
            .onChange(of: viewModel.filter) { _, _ in viewModel.applyFilters() }
            .toastQueue(viewModel.toastQueue)
            .sheet(isPresented: $showingFilterSheet) {
                UnifiedFilterView(
                    filter: $viewModel.filter,
                    availableSets: viewModel.availableSets
                ) {
                    viewModel.applyFilters()
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [generateShareText()])
            }
    }

    private func generateShareText() -> String {
        var text = "\(L10n.myCollection)\n\n"
        for card in viewModel.filteredItems.filter({ $0.quantity > 0 }) {
            text += "\(card.quantity)x \(card.name)\n"
        }
        return text
    }
}

#Preview {
    NavigationStack {
        UserCollectionView()
    }
    .environment(NavigationCoordinator())
    .environment(\.dependencyContainer, DependencyContainer.shared)
}
